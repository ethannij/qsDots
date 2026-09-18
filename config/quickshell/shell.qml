import QtQuick
//@ pragma UseQApplication
import Quickshell
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

        Rectangle {
            anchors.fill: parent
            color: "black"

            Text {
                id: text
                anchors.centerIn: parent
                font: StylizedFont.body
                color: "white"
                text: States.gamemode
            }

        }

    }

}
