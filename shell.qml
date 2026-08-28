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
            anchors.fill: parent
            color: "black"

            Button {
                id: button
                anchors.centerIn: parseInt
                text: "Inhibit Idle"
                onClicked: IdleInhibitor.inhibitIdle = !IdleInhibitor.inhibitIdle
            }

            Text {
                anchors.top: button.bottom
                text: "State: " + (IdleInhibitor.inhibitIdle ? "true" : "false") 
                color: "white"
            }
        }
    }
}
