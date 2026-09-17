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

            PillSlider {
                id: slider
                anchors.centerIn: parent
                sliderSize: StylizedFont.body.pixelSize / 2
            }

            Text {
                id: text
                anchors.left: slider.right
                color: "white"
                font: StylizedFont.tooltip
                text: slider.value.toFixed(2) + "%";
                anchors.verticalCenter: slider.verticalCenter
            }

        }

    }

}
