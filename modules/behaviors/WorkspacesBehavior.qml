import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import qs.services

Item {
    id: root

    property bool holdActivated: false

    Connections {
        target: Hyprland
        function onFocusedWorkspaceChanged() {root.show()}
    }

    function show() {
        PillController.showFace("workspaces")
    }

    Timer {
        id: holdTimer
        interval: 180
        repeat: false
        running: false
        onTriggered: {
            root.holdActivated = true
            PillController.showFace("workspaces")
        }
    }

    IpcHandler {
        id: ipc
        target: "hyprlandIpc"


    function superDown(): void {
                root.holdActivated = false
                holdTimer.start()
    }
    function superUp(): void {
       if (holdTimer.running) {
        holdTimer.stop()
       }

       if (root.holdActivated) {
        PillController.dismiss()
       } else {
        Quickshell.execDetached(["bash", "-c", "$HOME/.config/rofi/modules/launcher/launcher.sh || pkill rofi"])
       }
       root.holdActivated = false
    }
}}