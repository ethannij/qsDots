pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property bool active: false

    readonly property string enableLua: "GAMEMODE = true; fullscreen_anims(); hl.config({ decoration = { rounding = 0, blur = { enabled = false } }, general = { border_size = 0, gaps_in = 0, gaps_out = 0 } })"

    function toggle() {
        active = !active;
    }

    onActiveChanged: {
        if (active)
            Quickshell.execDetached(["hyprctl", "eval", "set_gamemode(true)"]);
        else
            Quickshell.execDetached(["hyprctl", "eval", "set_gamemode(false)"]);
    }

    IpcHandler {
        target: "gamemodeIpc"
        function toggleGamemode(): void {
            root.toggle();
        }
    }
}
