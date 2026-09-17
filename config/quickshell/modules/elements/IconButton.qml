import QtQuick
import qs.config
import qs.theme
import qs.modules.elements

Item {
    id: root
    property color backgroundColor: Colors.md3.surface_variant
    property color iconColor: Colors.md3.on_surface
    property int size: Config.iconSize
    required property url source

    property alias iconWidth: icon.implicitWidth
    property alias iconHeight: icon.implicitHeight
    property alias backgroundWidth: background.implicitWidth
    property alias backgroundHeight: background.implicitHeight
    property alias radius: background.radius

    implicitWidth: background.implicitWidth
    implicitHeight: background.implicitHeight

    Rectangle {
        id: background
        anchors.centerIn: parent
        implicitWidth: icon.size + Config.spaceMd
        implicitHeight: icon.size + Config.spaceMd
        radius: width * 0.3
        color: root.backgroundColor

        ColorizedIcon {
            id: icon
            anchors.centerIn: parent
            source: root.source
            size: root.size
            color: root.iconColor
        }

    }
}