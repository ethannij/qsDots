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

    implicitWidth: icon.implicitWidth + Config.spaceXl
    implicitHeight: icon.implicitHeight + Config.spaceXl
    radius: height / 2
    color: root.active ? Colors.md3.primary_container : hovered ? Colors.role.hover : Colors.role.chip

    Behavior on color {
        enabled: Config.animMs > 0
        ColorAnimation {
            duration: Config.animMs
            easing.type: Easing[Config.animEasingSmooth]
        }
    }

    ColorizedIcon {
        id: icon
        source: root.source
        size: Config.iconSize
        color: root.active ? Colors.md3.on_primary_container : Colors.role.muted

        Behavior on color {
            enabled: Config.animMs > 0
            ColorAnimation {
                duration: Config.animMs
                easing.type: Easing[Config.animEasingSmooth]
            }
        }
    }
}