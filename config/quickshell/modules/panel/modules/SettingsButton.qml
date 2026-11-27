import qs.modules.elements
import QtQuick
import Quickshell
import qs.theme
import qs.services

IconButton {
    id: root
    source: Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/system/settings.svg"))
    backgroundColor: buttonHover.hovered ? Colors.role.hover : "transparent"
    iconColor: buttonHover.hovered ? Colors.md3.primary : Colors.md3.on_surface

    HoverHandler {
        id: buttonHover
        cursorShape: Qt.PointingHandCursor
    }

    TapHandler {
        id: buttonTap
        onTapped: PillController.settingsWindowOpen = !PillController.settingsWindowOpen
        gesturePolicy: TapHandler.ReleaseWithinBounds
    }
}

