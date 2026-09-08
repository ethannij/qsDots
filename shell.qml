import QtQuick
//@ pragma UseQApplication
import Quickshell
import Quickshell.Services.UPower
import qs.modules
import qs.modules.windows
import qs.services

ShellRoot {
    id: root

    ControlBar {
    }

    // Debug window
    Window {
        width: 100
        height: 100
        visible: false

        Rectangle {
            anchors.fill: parent
            color: "black"

            Text {
                anchors.centerIn: parent
                color: "white"
                //text: UPower.devices.values.find(d => d.isLaptopBattery === true) ? "exists" : "null"
                text: Power.laptopBattery ? "exists" : "null"
            }

        }

    }

}
