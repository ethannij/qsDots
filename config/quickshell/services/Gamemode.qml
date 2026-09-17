pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs.services

Singleton {
    id: root

    readonly property bool active: States.gamemode

    function toggle() {
        States.gamemode = !States.gamemode;
    }

    onActiveChanged: {
        Quickshell.execDetached(["hyprctl", "eval", "set_gamemode(" + (active ? "true" : "false") + ")"]);
    }

    IpcHandler {
        target: "gamemodeIpc"
        function toggleGamemode(): void {
            root.toggle();
        }
    }
}
