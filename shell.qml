//@ pragma UseQApplication
import Quickshell
import QtQuick
import qs.modules
import qs.services
import QtQuick.Controls

ShellRoot {
    id: root
    ControlBar {}

    FloatingWindow {
        id: testWindow
        visible: true
        implicitWidth: 300
        implicitHeight: 300
        title: "Test Window"

        Rectangle {
            id: rect
            anchors.fill: parent
            color: "black"

            Text {
                id: text
                anchors.centerIn: parent
                text: "SCROLL ON ME"
                color: "white"
                font.pointSize: 40
                font.bold: true
            }
            WheelHandler {
                id: wheel
                acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                onWheel: (event) => {
                    console.log(event.angleDelta.y)
                    event.accepted = true
                }

            }

        }
    }
}
