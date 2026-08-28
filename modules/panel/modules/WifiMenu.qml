import QtQuick
import Quickshell
import qs.services
import qs.config
import qs.theme

FloatingWindow {
    id: root
    implicitHeight: 300
    implicitWidth: 300
    title: "Wifi Menu"
    visible: false

    Rectangle {
        anchors.fill: parent
        color: Colors.md3.surface
    }
}