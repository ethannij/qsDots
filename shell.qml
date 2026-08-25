//@ pragma UseQApplication
import Quickshell
import QtQuick
import qs.modules
import QtQuick.Controls
import qs.config
import qs.theme
import qs.services
import qs.modules.elements

ShellRoot {
    ControlBar {}

    FloatingWindow {
        id: testWindow
        visible: false
        implicitWidth: 300
        implicitHeight: 300
        title: "Test Window"

        Rectangle {
            anchors.fill: parent
            color: "black"
        }
    }
}
