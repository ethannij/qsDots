import Quickshell
import Quickshell.Services.Notifications
pragma Singleton

Singleton {
    id: root

    readonly property alias list: server.trackedNotifications
    readonly property int count: list.values.length
    property var latest: null

    function clearAll() {
        const items = root.list.values.slice();
        for (let i = items.length - 1; i >= 0; i--) items[i].dismiss()
    }

    NotificationServer {
        id: server

        bodySupported: true
        actionsSupported: true
        imageSupported: true
        onNotification: (notif) => {
            notif.tracked = true;
            root.latest = notif;
            notif.closed.connect(() => {
                if (root.latest === notif)
                    root.latest = null;

            });
        }
    }

}
