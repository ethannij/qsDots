import QtQuick
import qs.services
import qs.config
import qs.theme

Item {
    id: root
    property var notification: null
    implicitHeight: card.implicitHeight

    Rectangle {
        id: card
        anchors.left: parent.left
        anchors.right: parent.right
        implicitHeight: column.implicitHeight + Config.spaceMd * 2
        color: Colors.md3.surface_container
        radius: Config.radiusBox
        border.width: Config.borderWidth
        border.color: Colors.md3.outline_variant

        Column {
    id: column
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.margins: Config.spaceMd
    spacing: Config.spaceSm
    Item {
        width: parent.width
        height: Math.max(appName.implicitHeight, dismiss.implicitHeight)
        Text {
            id: appName
            anchors.left: parent.left
            anchors.right: dismiss.left
            anchors.rightMargin: Config.spaceSm
            anchors.verticalCenter: parent.verticalCenter
            text: root.notification?.appName || ""
            elide: Text.ElideRight
            font: StylizedFont.tooltip
            color: Colors.md3.on_surface_variant
        }
        Text {
            id: dismiss
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            text: "x"
            font: StylizedFont.icon
            color: dismissMouse.containsMouse ? Colors.md3.error : Colors.md3.on_surface_variant
            MouseArea {
                id: dismissMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (root.notification)
                        root.notification.dismiss()
                }
            }
        }
    }
    Text {
        width: parent.width
        text: root.notification?.summary || ""
        wrapMode: Text.Wrap
        font: StylizedFont.bold
        color: Colors.md3.on_surface
        visible: text.length > 0
    }
    Text {
        width: parent.width
        text: root.notification?.body || ""
        wrapMode: Text.Wrap
        font: StylizedFont.body
        color: Colors.md3.on_surface_variant
        visible: text.length > 0
    }
    Flow {
        width: parent.width
        spacing: Config.spaceSm
        visible: root.notification && root.notification.actions.length > 0
        Repeater {
            model: root.notification?.actions ?? []
            Rectangle {
                id: actionBtn
                required property var modelData
                implicitWidth: actionLabel.implicitWidth + Config.spaceMd
                implicitHeight: actionLabel.implicitHeight + Config.spaceSm
                radius: Config.radiusBox
                color: actionMouse.containsMouse ? Colors.md3.primary_container : Colors.md3.surface_container_high
                Text {
                    id: actionLabel
                    anchors.centerIn: parent
                    text: actionBtn.modelData.text
                    font: StylizedFont.body
                    color: Colors.md3.on_surface
                }
                MouseArea {
                    id: actionMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: actionBtn.modelData.invoke()
                }
            }
        }
    }
        }
    }

   
}