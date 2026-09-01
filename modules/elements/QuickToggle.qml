import QtQuick
import qs.config
import qs.theme
import qs.modules.elements

// Quick Toggle Elements for Panels
PillShape {
    id: root

    // Required properties for widgets
    required property url source
    property bool active: false

    implicitWidth: icon.implicitWidth + Config.spaceXl * 3
    implicitHeight: icon.implicitHeight + Config.spaceXl
    radius: height / 2
    color: hovered ? Colors.md3.primary_container : Colors.md3.surface_variant

    ColorizedIcon {
        id: icon
        source: root.source
        size: Config.iconSize
        color: root.active ? Colors.md3.tertiary : Colors.md3.on_surface_variant

    }
}