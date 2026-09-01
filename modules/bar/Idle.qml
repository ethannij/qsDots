import Quickshell
import QtQuick
import qs.modules.elements
import qs.theme
import qs.config


Item {
    id: root
    implicitWidth: indicator.implicitWidth
    implicitHeight: indicator.implicitHeight

    ColorizedIcon {
        id: indicator
        source: Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/idle/idle.svg"))
        color: Colors.md3.tertiary
        size: Config.barHeight * 0.5
    }

    HoverHandler {
        id: hover
        cursorShape: Qt.PointingHandCursor
    }
    TapHandler {
        gesturePolicy: TapHandler.ReleaseWithinBounds
        onTapped: Quickshell.execDetached(["qs", "ipc", "call", "inhibitIdleIpc", "toggleIdle"])
    }
}
