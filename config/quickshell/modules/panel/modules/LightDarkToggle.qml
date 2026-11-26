import Quickshell
import QtQuick
import qs.services
import qs.config
import qs.theme
import qs.modules.elements

IconButton {
    id: root
    source: ColorScheme.icon
    backgroundColor: buttonHover.hovered ? Colors.md3.surface_variant : "transparent"
    iconColor: buttonHover.hovered ? Colors.md3.primary : Colors.md3.on_surface

    HoverHandler {
        id: buttonHover
        cursorShape: Qt.PointingHandCursor
    }

    TapHandler {
        id: buttonTap
        onTapped: ColorScheme.cycleNext()
        gesturePolicy: TapHandler.ReleaseWithinBounds
    }
}

