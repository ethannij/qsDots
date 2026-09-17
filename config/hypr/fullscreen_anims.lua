GAMEMODE = false

local STATES = os.getenv("HOME") .. "/.local/state/quickshell/states.json"

local function read_gamemode()
    local f = io.open(STATES, "r")
    if not f then
        return false
    end
    local s = f: read("*a")
    f:close()
    return s:match('"gamemode"%s*:%s*true') ~= nil
end

function fullscreen_anims()
    local ws = hl.get_active_special_workspace() or hl.get_active_workspace()
    local fs = ws and (ws.fullscreen_mode or 0) or 0
    hl.config({ animations = { enabled = not GAMEMODE and fs < 2 } })
end

function set_gamemode(on)
    GAMEMODE = on and true or false
    fullscreen_anims()
    if on then
        hl.config({
            decoration = { rounding = 0, blur = { enabled = false } },
            general = { border_size = 0, gaps_in = 0, gaps_out = 0 },
        })
    else
        hl.config({
            decoration = { rounding = 14, blur = { enabled = true } },
            general = { border_size = 2, gaps_in = 5, gaps_out = 20 },
        })
    end
end

function apply_gamemode_from_state()
    local on = read_gamemode()
    if on ~= GAMEMODE then
        set_gamemode(on)
    end
end

fullscreen_anims()

hl.on("window.fullscreen", fullscreen_anims)
hl.on("workspace.active", fullscreen_anims)
hl.on("workspace.special_active", fullscreen_anims)

hl.timer(function()
    apply_gamemode_from_state()
end, { timeout = 400, type = "repeat" })