import Quickshell
import QtQuick
import qs.theme
import qs.config
import qs.services

Item {
    id: controlCenter

    implicitWidth: 600
    implicitHeight: 300

    Rectangle {
        anchors.fill: parent
        color: Colors.md3.surface
        radius: Config.radiusPill
    }
}
