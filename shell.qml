import QtQuick
//@ pragma UseQApplication
import Quickshell
import qs.modules
import qs.modules.windows
import qs.services
import Quickshell.Services.UPower

ShellRoot {
    id: root

    Component.onCompleted: {
    }

    ControlBar {
    }

    Window { // Debug window
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
