import QtQuick
import Quickshell
import Quickshell.Hyprland
import qs.modules.pill
import qs.services
import Quickshell.Io
import qs.config

Item {
    id: root
    
    Connections {
        target: Hyprland
        function onFocusedWorkspaceChanged() { root.show() }
    }

    function show() {
        PillController.showFace("workspaces")
        console.log("Showing workspaces face")
    }

    function dismiss() {
        PillController.dismiss()
        console.log("Dismissing workspaces face")
    }
    Timer {
            id: holdTimer
            interval: Config.holdMs
            repeat: false
            onTriggered: {
                ipc.holdActivated = true
                PillController.activeFace = "workspaces"
            }
        }

    IpcHandler {
        id: ipc
        target: "pill"

        property bool holdActivated: false

        
        // IPC is good, but messy because I'm still using rofi. behavior will change when launcher is created
        function superDown(): void {
            holdActivated = false
            holdTimer.restart()
        }

        function superUp(): void {
            holdTimer.stop()
            if (holdActivated) {
                PillController.dismiss()
        } else {
            Quickshell.execDetached([
                "bash", "-c", "$HOME/.config/rofi/modules/launcher/launcher.sh || pkill rofi"
            ])
        }
        holdActivated = false
        }

        // Unused, ideal IPC if launcher is created, might need hold logic still
        function showWorkspaces(): void {
            PillController.showFace("workspaces")
        }

        function dismiss(): void {
            PillController.dismiss()
        }
    }

}