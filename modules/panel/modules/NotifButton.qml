import QtQuick
import Quickshell.Widgets
import QtQuick.Effects
import qs.services
import qs.config
import qs.theme

Item {
    id: notifButton

    property bool active: PillController.page === "notifications"

    implicitHeight: notifIconColumn.implicitHeight * 1.2
    implicitWidth: notifIconColumn.implicitWidth * 1.2

    property url notificationIconDynamic: {
        if (Notifications.list.values.length > 0 && !Notifications.doNotDisturb)
            return Qt.resolvedUrl("../../img/widgets/notifications/notification_unread.svg");
        if (Notifications.list.values.length === 0 && !Notifications.doNotDisturb)
            return Qt.resolvedUrl("../../img/widgets/notifications/notification.svg");
        if (Notifications.doNotDisturb)
            return Qt.resolvedUrl("../../img/widgets/notifications/notification_paused.svg");
    }

    Rectangle {
        id: rect
        anchors.fill: parent
        radius: width * 0.3
        color: hover.hovered ? Colors.md3.surface_variant : "transparent"

        HoverHandler {
            id: hover
            cursorShape: Qt.PointingHandCursor
        }

        TapHandler {
            id: tapLeft
            acceptedButtons: Qt.LeftButton
            gesturePolicy: TapHandler.ReleaseWithinBounds
            onTapped: PillController.page = PillController.page === "notifications" ? "home" : "notifications"
        }

        TapHandler {
            id: tapRight
            acceptedButtons: Qt.RightButton
            gesturePolicy: TapHandler.ReleaseWithinBounds
            onTapped: Notifications.clearAll();
        }

        TapHandler {
            id: tapMiddle
            acceptedButtons: Qt.MiddleButton
            gesturePolicy: TapHandler.ReleaseWithinBounds
            onTapped: Notifications.doNotDisturb = !Notifications.doNotDisturb
        }

        Column {
            id: notifIconColumn
            spacing: Config.spaceXs
            anchors.centerIn: parent

            Item {
                implicitWidth: notifIcon.implicitWidth
                implicitHeight: notifIcon.implicitHeight
                anchors.horizontalCenter: parent.horizontalCenter

                IconImage {
                    id: notifIcon
                    anchors.centerIn: parent
                    source: notifButton.notificationIconDynamic
                    implicitSize: Config.iconSize
                    backer.fillMode: Image.PreserveAspectCrop
                }

                MultiEffect {
                    id: notifIconEffect
                    source: notifIcon
                    anchors.fill: notifIcon
                    colorization: 1
                    colorizationColor: hover.hovered ? Colors.md3.primary : Colors.md3.on_surface
                }
            }

            Text {
                id: notifCount
                visible: Notifications.list.values.length > 0
                anchors.horizontalCenter: parent.horizontalCenter
                text: Notifications.count
                font: StylizedFont.tooltip
                color: Colors.md3.tertiary
            }
        }
    }
}
