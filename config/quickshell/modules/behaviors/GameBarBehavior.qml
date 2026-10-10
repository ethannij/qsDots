import QtQuick
import Quickshell.Io
import qs.services

Item {
    id: root
    
    property bool readySeen: false

    function toggle() {
        if (PillController.activeFace === "gamebar")
            PillController.releaseGamebar();
        else
            PillController.holdGamebar();
    }

    IpcHandler {
        id: ipc
        target: "gamebarIpc"

        function toggleGamebar(): void {
            root.toggle();
        }
    }
}