//@ pragma UseQApplication
import Quickshell
import QtQuick
import qs.modules
import qs.services
import QtQuick.Controls
import Quickshell.Hyprland

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
                text: Monitors.monitorNames[0]
                color: "white"
                font.pointSize: 40
                font.bold: true
            }
        }
    }
}
