import QtQuick
import qs.services
import Quickshell

Item {
    id: root

    Connections {
        target: Notifications
        function onLatestChanged() {
            if (Notifications.latest) {
                PillController.showFace("notification")
            }
        }
    }
}