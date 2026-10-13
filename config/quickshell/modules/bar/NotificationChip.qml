import QtQuick
import Quickshell
import qs.services
import qs.config
import qs.theme
import qs.modules.elements

Item {
    id: root

    implicitWidth: circle.implicitWidth
    implicitHeight: circle.implicitHeight

    property alias color: circle.color

    ColorizedIcon {
        id: circle
        anchors.centerIn: parent
        source: Qt.resolvedUrl(Quickshell.shellPath("/modules/img/widgets/notifications/circle.svg"))
        color: root.color

        Text {
            id: number
            anchors.centerIn: parent
            text: Notifications.unreadCount
            color: Colors.md3.surface
            font: StylizedFont.tooltip
        }
    }
}