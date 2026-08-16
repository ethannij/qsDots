import qs.services
import QtQuick
import qs.config
import qs.theme

Item {
    id: root
    property int cpuUsage: SystemStats.cpuUsage
    property alias color: text.color
    implicitWidth: text.implicitWidth
    implicitHeight: text.implicitHeight

    Text {
        id: text
        text: " " + root.cpuUsage + "%"
        font: StylizedFont.body
        color: Colors.md3.on_surface
    }
}