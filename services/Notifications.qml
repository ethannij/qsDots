pragma Singleton
import Quickshell
import Quickshell.Services.Notifications

Singleton {
    id: root

    readonly property alias list: server.trackedNotifications
    property var latest: null

    NotificationServer {
        id: server

        bodySupported: true
        actionsSupported: true
        imageSupported: true

        onNotification: notif => {
            notif.tracked = true
            root.latest = notif
        }
    }
}