pragma Singleton
import Quickshell
import Quickshell.Services.Notifications
import qs.modules.panel
import QtQuick

Singleton {
    id: root

    readonly property alias list: server.trackedNotifications
    readonly property int count: list.values.length
    property var latest: null
    property bool doNotDisturb: false
    property int unreadCount: 0

    function clearAll() {
        const items = root.list.values.slice();
        for (let i = items.length - 1; i >= 0; i--)
            items[i].dismiss();
    }

    onCountChanged: unreadCount = count - list.values.filter(notif => notif.read).length

    Connections {
        target: PillController

        function onPageChanged() {
            if (PillController.page === "notifications")
                root.unreadCount = 0;
        }
    }

    NotificationServer {
        id: server

        bodySupported: true
        actionsSupported: true
        imageSupported: true
        onNotification: notif => {
            notif.tracked = true;
            root.latest = notif;
            notif.closed.connect(() => {
                if (root.latest === notif)
                    root.latest = null;
            });
        }
    }
}
