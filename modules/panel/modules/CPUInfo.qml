import qs.services
import QtQuick
import qs.config
import qs.theme

Item {
    id: root
    property int cpuUsage: CPU.cpuUsage
    property alias color: text.color
    implicitWidth: text.implicitWidth
    implicitHeight: text.implicitHeight

    Text {
        id: text
        text: " " + root.cpuUsage + "%"
        font {
            family: Config.fontFamilyPropo
            pointSize: Config.fontSize
            weight: Config.fontWeight
        }
        color: Colors.md3.on_surface
    }
}