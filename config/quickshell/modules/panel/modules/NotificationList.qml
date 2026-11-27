import QtQuick
import qs.services
import qs.config
import qs.theme

Item {
    id: root

    readonly property int maxHeight: 360
    readonly property int emptyHeight: emptyLabel.implicitHeight + Config.spaceLg * 2
    implicitHeight: list.count === 0 ? emptyHeight : Math.min(list.contentHeight, maxHeight)

    ListView {
        id: list
        anchors.fill: parent
        model: Notifications.list
        clip: true
        spacing: Config.spaceSm
        boundsBehavior: Flickable.StopAtBounds
        reuseItems: true

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
        color: Colors.role.muted
    }
}
