import QtQuick
import Quickshell
import qs.config
import qs.theme
pragma ComponentBehavior: Bound

Item {
    id: root

    implicitWidth: button.width
    implicitHeight: button.height

    Rectangle {
        id: button

        anchors.fill: parent
        color: "transparent"
        implicitWidth: text.width
        implicitHeight: text.height

        Text {
            id: text

            text: "󰐥"
            color: mouse.containsMouse ? Colors.md3.on_surface_variant : Colors.md3.error

            font: StylizedFont.body

        }

    }

    readonly property var actions: [
        { label: "shutdown", cmd: ["systemctl", "poweroff"]},
        { label: "reboot", cmd: ["systemctl", "reboot"]},
        { label: "logout", cmd: ["loginctl", "terminate-session", Quickshell.env("XDG_SESSION_ID")]},
        { label: "suspend", cmd: ["systemctl", "suspend"]},
        { label: "hibernate", cmd: ["systemctl", "hibernate"]},
        { label: "lock", cmd: ["hyprlock"]},
    ]

    Rectangle {
        id: background

        color: Colors.md3.secondary_container
        border.color: Colors.md3.on_surface
        implicitHeight: column.height + Config.sessionMenuPadding
        implicitWidth: column.width + Config.sessionMenuPadding
        anchors.top: button.bottom
        anchors.right: button.right
        opacity: 0
        radius: Config.radiusBox

        Behavior on opacity {
            NumberAnimation {
                duration: Config.animMs
                easing.type: Easing.InOutCubic
            }
        }

        Column {
            id: column

            spacing: Config.sessionMenuEntrySpacing

            anchors.centerIn: parent
            Repeater {
                model: root.actions
                Item {
                    id: entry
                    required property var modelData
                    width: Math.max(label.implicitWidth, background.width - 16)
                    height: label.implicitHeight

                    Text {
                        id: label
                        anchors.centerIn: parent
                        text: entry.modelData.label
                        color: entryMouse.containsMouse ? Colors.md3.primary : Colors.md3.on_surface
                        font: StylizedFont.body
                    }
                    MouseArea {
                        id: entryMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            Quickshell.execDetached(entry.modelData.cmd)
                            background.visible = false
                        }
                        visible: background.opacity > 0
                    }
                }
            }

        }

    }

    MouseArea {
        id: mouse

        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            background.opacity = background.opacity === 0 ? 1 : 0
        }
    }

   

}
