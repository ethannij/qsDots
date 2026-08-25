import QtQuick
import qs.services
import qs.config
import qs.theme

Item {
    id: notifButton

    property color buttonColor: Colors.md3.on_surface
    property color buttonActiveColor: Colors.md3.primary

    property bool active: PillController.page === "notifications"

    implicitWidth: notifBell.implicitWidth + (notifCount.visible ? Config.spaceXs + notifCount.implicitWidth : 0)
    implicitHeight: Math.max(notifBell.implicitHeight, notifCount.implicitHeight)

    Row {
        spacing: Config.spaceXs
        layoutDirection: notifButton.active ? Qt.RightToLeft : Qt.LeftToRight

        Text {
            id: notifBell
            anchors.verticalCenter: parent.verticalCenter
            text: PillController.page === "notifications" ? "󰂞" : "󰂚"
            font: StylizedFont.icon
            color: bellMouse.containsMouse || PillController.page === "notifications" ? notifButton.buttonActiveColor : notifButton.buttonColor

            MouseArea {
                id: bellMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: mouse => {
                    if (mouse.button === Qt.RightButton)
                        Notifications.clearAll();
                    else if (mouse.button === Qt.LeftButton)
                        PillController.page = PillController.page === "notifications" ? "home" : "notifications";
                }
            }
        }

        Text {
            id: notifCount
            anchors.verticalCenter: notifBell.verticalCenter
            visible: Notifications.list.values.length > 0
            text: Notifications.count
            font: StylizedFont.tooltip
            color: Colors.md3.tertiary
        }
    }
}
