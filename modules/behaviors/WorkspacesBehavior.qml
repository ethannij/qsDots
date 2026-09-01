import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import qs.services

Item {
    id: root

    property bool readySeen: false

    Connections {
        target: Hyprland
        function onFocusedWorkspaceChanged() {
            if (!Hyprland.focusedWorkspace)
                return;
            if (!root.readySeen) {
                Qt.callLater(() => {
                    root.readySeen = true;
                });
                return;
            }
            root.show();
        }
    }

    function show() {
        PillController.showFace("workspaces");
    }
}
