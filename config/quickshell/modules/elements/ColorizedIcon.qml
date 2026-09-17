import Quickshell.Widgets
import QtQuick
import QtQuick.Effects
import qs.config
import qs.theme

Item {

    // Icon Image + MultiEffect to colorize sized icons
    id: root
    implicitWidth: icon.implicitSize
    implicitHeight: icon.implicitSize
    required property url source
    property color color: Colors.md3.on_surface
    property int size: Config.iconSize

    IconImage {
        id: icon
        anchors.centerIn: parent
        source: root.source
        backer.fillMode: Image.PreserveAspectCrop
        implicitSize: root.size
        visible: false // Hides icon to prevent fighting with the colorization effect
    }

    MultiEffect {
        id: iconColorization
        anchors.fill: icon
        source: icon
        colorizationColor: root.color
        colorization: 1
    }
}