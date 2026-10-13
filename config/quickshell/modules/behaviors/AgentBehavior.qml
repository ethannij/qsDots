import QtQuick
import Quickshell.Io
import qs.services

Item {
    id: root
    
    property bool readySeen: false

    function toggle() {
        if (PillController.activeFace === "agent")
            PillController.releaseAgent();
        else
            PillController.holdAgent();
    }

    IpcHandler {
        id: ipc
        target: "agentIpc"

        function toggleAgent(): void {
            root.toggle();
        }
    }
}