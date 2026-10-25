import QtQuick
import Quickshell
import qs.services
import qs.modules.elements
import qs.config
import qs.theme

Item {
    id: expandButton

    implicitHeight: expandSlot.implicitHeight
    implicitWidth: expandSlot.implicitWidth



    property bool expanded: false
    property bool barHovered: false

    Item {
        id: expandSlot
        implicitHeight: height
        height: (expandButton.barHovered || expandButton.expanded) ? expandIcon.implicitHeight : 0
        width: expandIcon.implicitWidth
        clip: true

        Behavior on height {
            enabled: Config.animMs > 0
            NumberAnimation {
                duration: expandButton.expanded ? Config.animMs : Config.animMsClose
                easing.type: expandButton.expanded ? Easing.OutCubic : Easing.InCubic
            }
        }

        ColorizedIcon {
            id: expandIcon
            source: Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/bar/arrow_down.svg"))
            color: expandHover.hovered ? Colors.md3.primary : Colors.md3.on_surface

            HoverHandler {
                id: expandHover
            }
        }
    }
}