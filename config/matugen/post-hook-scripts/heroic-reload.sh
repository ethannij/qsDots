#!/usr/bin/env bash
# Heroic reads its theme CSS when the window is created. Restart the client
# after matugen writes the theme, but keep it on the workspace it already
# occupied and leave focus on whatever the user is working in.
if ! pgrep -f '/usr/lib/heroic-games-launcher/app.asar' >/dev/null 2>&1; then
	exit 0
fi

if ! hyprctl instances >/dev/null 2>&1; then
	exit 0
fi

python3 - <<'PY'
import json
import os
import subprocess
import sys
import time

RULE = "qs-heroic-theme-reload"
CLASSES = {"heroic", "com.heroicgameslauncher.hgl"}


def hypr(*args):
    return subprocess.check_output(["hyprctl", *args], text=True)


def clients():
    return json.loads(hypr("clients", "-j"))


def active():
    raw = hypr("activewindow", "-j").strip()
    return json.loads(raw) if raw else {}


def lua_string(value):
    return json.dumps(value)


def is_heroic(window):
    names = {window.get("class") or "", window.get("initialClass") or ""}
    return bool(names & CLASSES) and window.get("mapped")


def heroic_windows():
    return [c for c in clients() if is_heroic(c)]


def workspace_name(window):
    workspace = window["workspace"]
    return str(workspace.get("name") or workspace["id"])


def repl(code):
    return hypr("repl", code)


def main_pids():
    out = subprocess.check_output(["ps", "-eo", "pid=,args="], text=True)
    pids = []
    for line in out.splitlines():
        line = line.strip()
        if "heroic-games-launcher/app.asar" not in line or "--type=" in line:
            continue
        pids.append(int(line.split(None, 1)[0]))
    return pids


def alive(pid):
    try:
        os.kill(pid, 0)
    except OSError:
        return False
    return True


def stop(pids):
    for pid in pids:
        try:
            os.kill(pid, 15)
        except OSError:
            pass
    deadline = time.time() + 5
    while time.time() < deadline and any(alive(pid) for pid in pids):
        time.sleep(0.1)
    for pid in pids:
        if not alive(pid):
            continue
        try:
            os.kill(pid, 9)
        except OSError:
            pass


def disarm():
    repl(
        f"""
local rule = hl.window_rule({{
    name = {lua_string(RULE)},
    match = {{ class = "^heroic$" }},
}})
rule:set_enabled(false)
return "disarmed"
"""
    )


windows = heroic_windows()
if not windows:
    # Nothing is on screen. Restarting would open a window here.
    sys.exit(0)

main = next((c for c in windows if "Heroic" in (c.get("title") or "")), windows[0])
workspace = workspace_name(main)
before = active()
focus = before.get("address") or ""
in_heroic = (before.get("class") or "") in CLASSES

repl(
    f"""
local rule = hl.window_rule({{
    name = {lua_string(RULE)},
    match = {{ class = "^heroic$" }},
    workspace = {lua_string(workspace + " silent")},
    no_initial_focus = true,
    suppress_event = "activate",
}})
rule:set_enabled(true)
return "armed"
"""
)

try:
    stop(main_pids())
    subprocess.Popen(
        ["heroic"],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
        start_new_session=True,
    )
    deadline = time.time() + 12
    returned = False
    while time.time() < deadline:
        time.sleep(0.1)
        now = heroic_windows()
        if not now:
            continue
        returned = True
        for window in now:
            if workspace_name(window) == workspace:
                continue
            repl(
                f"""
local w = hl.get_window("address:{window["address"]}")
if w then
    hl.dispatch(hl.dsp.window.move({{ window = w, workspace = {lua_string(workspace)}, follow = false }}))
end
return "moved"
"""
            )
        if any(workspace_name(window) == workspace for window in heroic_windows()):
            time.sleep(0.35)
            break
finally:
    try:
        disarm()
    except subprocess.CalledProcessError as error:
        print(error.output or error, file=sys.stderr)

if not returned:
    sys.exit(0)

target = ""
if in_heroic:
    again = heroic_windows()
    chosen = next((c for c in again if "Heroic" in (c.get("title") or "")), again[0] if again else None)
    if chosen:
        target = chosen["address"]
elif focus:
    target = focus

if target and active().get("address") != target:
    repl(
        f"""
local w = hl.get_window("address:{target}")
if w then hl.dispatch(hl.dsp.focus({{ window = w }})) end
return "focused"
"""
    )
PY
