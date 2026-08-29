import QtQuick
import qs.theme
import qs.config
import qs.modules.elements
import qs.services
import qs.modules.panel

PillShape {
    id: root

    readonly property var notif: Notifications.latest

    Text {
        text: {
            if (!root.notif)
                return "No notifications"
            const app = root.notif.appName || ""
            const summary = root.notif.summary || ""
            const icon = root.notif.icon || ""
            if (summary && icon)
                return icon + ": " + summary + " 󰂚"
            return (summary || app || icon || "Notification") + " 󰂚"
        }

        elide: Text.ElideRight
        maximumLineCount: 1
        width: Math.min(implicitWidth, 600)

        font: StylizedFont.body
        color: Colors.md3.tertiary
    }

    interactive: !!root.notif
    onClicked: {
        if (root.notif) {
            PillController.panelOpen = true
            ControlPanel.page = "notifications"
        }
    }

}