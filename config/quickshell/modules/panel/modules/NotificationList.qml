import QtQuick
import qs.services
import qs.config
import qs.theme

Item {
    id: root

    readonly property int maxHeight: 280
    implicitHeight: list.count === 0 ? emptyLabel.implicitHeight + Config.spaceLg : Math.min(list.contentHeight, maxHeight)

    ListView {
        id: list
        anchors.fill: parent
        model: Notifications.list
        clip: true
        spacing: Config.spaceMd
        boundsBehavior: Flickable.StopAtBounds

        delegate: NotificationCard {
            required property var modelData
            width: ListView.view.width
            height: implicitHeight
            notification: modelData
        }
    }

    Text {
        id: emptyLabel
        anchors.centerIn: parent
        visible: list.count === 0
        text: "No notifications"
        font: StylizedFont.body
        color: Colors.md3.on_surface_variant
    }
}
