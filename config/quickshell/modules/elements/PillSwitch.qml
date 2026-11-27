import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import qs.theme
import qs.config
import qs.modules.elements

Switch {
    width: 45
    height: 20

    HoverHandler {
        cursorShape: Qt.PointingHandCursor
    }


    background: Rectangle {
        id: backgroundChecked
        width: parent.width
        height: parent.height
        color: parent.checked ? Colors.md3.primary : Colors.role.track
        radius: Config.radiusPill
        Behavior on color {
            ColorAnimation {
                duration: Config.animMs
                easing.type: Easing[Config.animEasingOut]
            }
        }
    }
    indicator: Rectangle {
        id: indicator
        width: parent.height
        height: parent.height
        radius: parent.height
        color: parent.checked ? Colors.md3.on_primary : Colors.md3.on_surface_variant
        x: parent.checked ? parent.width - width : 0

        Behavior on color {
            ColorAnimation {
                duration: Config.animMs
                easing.type: Easing[Config.animEasingOut]
            }
        }

        Behavior on x {
            NumberAnimation {
                duration: Config.animMs
                easing.type: Easing[Config.animEasingOut]
            }
        }
    }
}
