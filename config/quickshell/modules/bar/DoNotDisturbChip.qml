import QtQuick
import Quickshell
import qs.services
import qs.config
import qs.theme
import qs.modules.elements

ColorizedIcon {
    id: root

    source: Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/notifications/notification_paused.svg"))
    size: Config.barIconSize

    HoverHandler {
        id: hover
        cursorShape: Qt.PointingHandCursor
    }

    TapHandler {
        onTapped: Notifications.toggleDoNotDisturb()
    }
}
