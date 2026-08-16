import QtQuick
import qs.services

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