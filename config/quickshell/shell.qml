import QtQuick
//@ pragma UseQApplication
import Quickshell
import Quickshell.Wayland
import QtQuick.Controls
import Quickshell.Services.UPower
import qs.modules
import qs.modules.windows
import qs.modules.elements
import qs.services
import qs.config

ShellRoot {
    id: root

    ControlBar {
    }

    // Debug window
    Window {
        width: 300
        height: 300
        visible: false
        title: "testWindow"

        Button {
            anchors.centerIn: parent
            text: "Toggle Gamebar"
            onClicked: PillController.gameBarOpen = !PillController.gameBarOpen
        }

    }

}
