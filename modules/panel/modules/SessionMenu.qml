import QtQuick
import Quickshell
import qs.config
import qs.theme
import qs.services
import qs.modules.elements
pragma ComponentBehavior: Bound

Item {
    id: root

    implicitWidth: button.width
    implicitHeight: button.height

    IconButton {
        id: button
        backgroundColor: buttonHover.hovered ? Colors.md3.surface_variant : "transparent"
        iconColor: buttonHover.hovered ? Colors.md3.primary : Colors.md3.error
        source: Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/ui/power_button.svg"))

        HoverHandler {
            id: buttonHover
            cursorShape: Qt.PointingHandCursor
        }

        TapHandler {
            id: buttonTap
            onTapped: PillController.sessionMenuOpen = !PillController.sessionMenuOpen
            gesturePolicy: TapHandler.ReleaseWithinBounds
        }
    }

    readonly property var actions: [
        { label: "shutdown", cmd: ["systemctl", "poweroff"]},
        { label: "reboot", cmd: ["systemctl", "reboot"]},
        { label: "logout", cmd: ["loginctl", "terminate-session", Quickshell.env("XDG_SESSION_ID")]},
        { label: "sleep", cmd: ["systemctl", "suspend"]},
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
        opacity: PillController.sessionMenuOpen ? 1 : 0
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
                        color: entryHover.hovered ? Colors.md3.primary : Colors.md3.on_surface
                        font: StylizedFont.body

                        HoverHandler {
                            id: entryHover
                            enabled: background.opacity > 0
                            cursorShape: Qt.PointingHandCursor
                        }

                        TapHandler {
                            id: entryTap
                            enabled: background.opacity > 0
                            onTapped: {
                                Quickshell.execDetached(entry.modelData.cmd)
                                PillController.closePanel()

                            }
                           gesturePolicy: TapHandler.ReleaseWithinBounds

                        }
                    }
                }
            }

        }

    }
}
