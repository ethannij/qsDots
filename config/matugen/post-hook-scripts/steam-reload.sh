#!/usr/bin/env bash
# Steam reads custom.css when steamwebhelper starts. Restart that process,
# but keep the client on the workspace it already occupied and leave focus
# on whatever the user is working in.
if ! pgrep -x steamwebhelper >/dev/null 2>&1; then
	exit 0
fi

if ! hyprctl instances >/dev/null 2>&1; then
	pkill -x steamwebhelper || true
	exit 0
fi

python3 - <<'PY'
import json
import subprocess
import sys
import time

RULE = "qs-steam-theme-reload"


def hypr(*args):
    return subprocess.check_output(["hyprctl", *args], text=True)


def clients():
    return json.loads(hypr("clients", "-j"))


def active():
    raw = hypr("activewindow", "-j").strip()
    return json.loads(raw) if raw else {}


def lua_string(value):
    return json.dumps(value)


def steam_windows():
    return [c for c in clients() if c.get("class") == "steam" and c.get("mapped")]


def workspace_name(window):
    workspace = window["workspace"]
    return str(workspace.get("name") or workspace["id"])


def repl(code):
    return hypr("repl", code)


def disarm():
    repl(
        f"""
local rule = hl.window_rule({{
    name = {lua_string(RULE)},
    match = {{ class = "^steam$" }},
}})
rule:set_enabled(false)
return "disarmed"
"""
    )


steam = steam_windows()
if not steam:
    # Nothing is on screen. Restarting the UI would open a window here.
    sys.exit(0)

main = next((c for c in steam if c.get("title") == "Steam"), steam[0])
workspace = workspace_name(main)
before = active()
focus = before.get("address") or ""
in_steam = before.get("class") == "steam"

repl(
    f"""
local rule = hl.window_rule({{
    name = {lua_string(RULE)},
    match = {{ class = "^steam$" }},
    workspace = {lua_string(workspace + " silent")},
    no_initial_focus = true,
    suppress_event = "activate",
}})
rule:set_enabled(true)
return "armed"
"""
)

try:
    subprocess.call(["pkill", "-x", "steamwebhelper"])
    deadline = time.time() + 8
    returned = False
    while time.time() < deadline:
        time.sleep(0.1)
        now = steam_windows()
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
        if any(workspace_name(window) == workspace for window in steam_windows()):
            time.sleep(0.35)
            break
finally:
    try:
        disarm()
    except subprocess.CalledProcessError as error:
        print(error.output or error, file=sys.stderr)

if not returned:
    sys.exit(0)

# The rule is gone, so focus can move again. Put it back on Steam only when
# that is where the user already was.
target = ""
if in_steam:
    again = steam_windows()
    chosen = next((c for c in again if c.get("title") == "Steam"), again[0] if again else None)
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
