import QtQuick
import qs.services
import qs.config
import qs.theme

Item {
    ListView {
        anchors.fill: parent
        model: Notifications.list
        clip: true
        spacing: Config.spaceMd

        delegate: NotificationCard {
            required property var modelData
            width: ListView.view.width
            height: implicitHeight
            notification: modelData
        }

    }
    Text {
    anchors.centerIn: parent
    visible: Notifications.list.values.length === 0
    text: "No notifications"
    font: StylizedFont.body
    color: Colors.md3.on_surface_variant
}
}