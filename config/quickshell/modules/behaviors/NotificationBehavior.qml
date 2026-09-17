import QtQuick
import qs.services

Item {
    id: root

    Connections {
        target: Notifications
        function onLatestChanged() {
            if (Notifications.latest && !Notifications.doNotDisturb) {
                PillController.showFace("notification");
            }
        }
    }
}
