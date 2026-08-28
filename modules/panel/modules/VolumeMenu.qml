import QtQuick
import qs.services
import qs.theme
import qs.config
import Quickshell.Widgets

Item {
    id: root
    implicitWidth: Math.max(rect.implicitWidth, menu.implicitWidth)
    implicitHeight: Math.max(rect.implicitHeight, menu.implicitHeight)

    property bool isMenuOpen: false

    Rectangle {
        id: rect
        anchors.centerIn: parent
        implicitWidth: text.width + Config.spaceSm
        implicitHeight: text.implicitHeight + Config.spaceSm
        color: Colors.md3.surface_variant
        radius: 10
        z: 1

        Text {
            id: text
            anchors.centerIn: parent
            text: Audio?.sink?.description ?? ""
            elide: Text.ElideRight
            clip: true
            width: 100
            color: Colors.md3.secondary
            font: StylizedFont.body
        }

        MouseArea {
            id: mouse
            anchors.fill: rect
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                root.isMenuOpen = !root.isMenuOpen;
            }
        }
    }

    Rectangle {
        id: menu
        anchors.left: rect.right
        anchors.verticalCenter: rect.verticalCenter
        implicitWidth: column.implicitWidth
        implicitHeight: column.implicitHeight
        color: Colors.md3.surface_variant
        visible: root.isMenuOpen
        enabled: visible
        radius: 6

        Column {
            id: column
            anchors.margins: Config.spaceSm
            spacing: Config.spaceSm
            anchors.centerIn: parent

            Repeater {
                model: Audio.sinks

                Text {
                    id: menuText
                    required property var modelData
                    color: menuMouse.containsMouse ? Colors.md3.primary : Colors.md3.on_surface_variant
                    text: modelData.description
                    font: StylizedFont.tooltip
                    elide: Text.ElideRight
                    clip: true
                    width: 200

                    MouseArea {
                        id: menuMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            Audio.setDefaultSink(modelData);
                            root.isMenuOpen = false
                        }
                    }
                }
            }
        }
    }
}
