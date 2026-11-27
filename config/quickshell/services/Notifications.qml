pragma Singleton
import Quickshell
import Quickshell.Services.Notifications
import qs.modules.panel
import QtQuick
import qs.services
import qs.config

Singleton {
    id: root

    readonly property alias list: server.trackedNotifications
    readonly property int count: list.values.length
    property var latest: null
    readonly property bool doNotDisturb: States.doNotDisturb
    property var arrivalTimes: ({})
    property int timeTick: 0

    function toggleDoNotDisturb() {
        States.doNotDisturb = !States.doNotDisturb;
    }
    property int unreadCount: 0

    function clearAll() {
        const items = root.list.values.slice();
        for (let i = items.length - 1; i >= 0; i--)
            items[i].dismiss();
    }

    function clearUnread() {
        root.unreadCount = 0;
    }

    function markArrival(notif) {
        if (!notif)
            return;
        const next = Object.assign({}, root.arrivalTimes);
        next[notif.id] = Date.now();
        root.arrivalTimes = next;
    }

    function clearArrival(id) {
        if (root.arrivalTimes[id] === undefined)
            return;
        const next = Object.assign({}, root.arrivalTimes);
        delete next[id];
        root.arrivalTimes = next;
    }

    function arrivedAt(notif) {
        if (!notif)
            return 0;
        return root.arrivalTimes[notif.id] || 0;
    }

    function formatArrival(notif) {
        void root.timeTick;
        const t = root.arrivedAt(notif);
        if (!t)
            return "";

        const delta = Math.max(0, Date.now() - t);
        if (delta < 60000)
            return "now";
        if (delta < 3600000)
            return Math.floor(delta / 60000) + "m";
        if (delta < 86400000)
            return Math.floor(delta / 3600000) + "h";

        const d = new Date(t);
        const today = new Date();
        if (d.toDateString() === today.toDateString())
            return Qt.formatTime(d, Config.clockFormat);
        return Qt.formatDate(d, "MMM d");
    }

    onCountChanged: unreadCount = count - list.values.filter(notif => notif.read).length

    Timer {
        interval: 30000
        running: root.count > 0
        repeat: true
        onTriggered: root.timeTick++
    }

    Connections {
        target: PillController

        function onPanelOpenChanged() {
            if (PillController.panelOpen)
                root.clearUnread();
        }
    }

    NotificationServer {
        id: server

        bodySupported: true
        actionsSupported: true
        imageSupported: true
        onNotification: notif => {
            notif.tracked = true;
            root.markArrival(notif);
            root.latest = notif;
            notif.closed.connect(() => {
                root.clearArrival(notif.id);
                if (root.latest === notif)
                    root.latest = null;
            });
        }
    }
}
