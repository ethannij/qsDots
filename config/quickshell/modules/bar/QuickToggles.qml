import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.services
import qs.config
import qs.theme
import qs.modules.elements

Item {
    id: quickToggles

    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight

    property bool expanded: false
    property bool barHovered: false

    // Object Assignments
    QtObject {
        id: wifi
        property url icon: Networks.statusIcon
        property bool active: Networks.wifiEnabled
        function trigger() {
            Networks.toggleWifi();
        }
        function triggerAlternate() {
            PillController.showWifi();
        }
    }

    QtObject {
        id: bluetooth
        property url icon: Bluetooth.statusIcon
        property bool active: Bluetooth.enabled
        function trigger() {
            Bluetooth.toggleEnabled();
        }
        function triggerAlternate() {
            PillController.showBluetooth();
        }
    }

    QtObject {
        id: wled
        property bool visible: WLED.wledExists
        property url icon: Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/wled/wled.svg"))
        property bool active: WLED.on
        function trigger() {
            WLED.toggle();
        }
        function triggerAlternate() {
            WLED.refresh();
        }
    }

    QtObject {
        id: idle
        property url icon: Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/idle/idle.svg"))
        property bool active: IdleInhibitor.inhibitIdle
        function trigger() {
            Quickshell.execDetached(["qs", "ipc", "call", "inhibitIdleIpc", "toggleIdle"]);
        }
    }

    QtObject {
        id: gamemode
        property url icon: Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/gamemode/gamemode.svg"))
        property bool active: Gamemode.active
        function trigger() {
            Quickshell.execDetached(["qs", "ipc", "call", "gamemodeIpc", "toggleGamemode"]);
        }
    }

    QtObject {
        id: oled
        property url icon: OLED.icon
        property bool active: OLED.active
        function trigger() {
            OLED.toggle();
        }
    }

    // UI
    Row {
        id: row
        spacing: 0

        Item {
            id: expandSlot
            width: (quickToggles.barHovered || quickToggles.expanded) ? expandIcon.implicitWidth : 0
            height: expandIcon.implicitHeight
            clip: true

            Behavior on width {
                enabled: Config.animMs > 0
                NumberAnimation {
                    duration: quickToggles.expanded ? Config.animMs : Config.animMsClose
                    easing.type: quickToggles.expanded ? Easing.OutCubic : Easing.InCubic
                }
            }

            ColorizedIcon {
                id: expandIcon
                source: Qt.resolvedUrl(Quickshell.shellPath("/modules/img/widgets/bar/expand.svg"))
                color: expandHover.hovered ? Colors.md3.primary : Colors.md3.on_surface

                HoverHandler {
                    id: expandHover
                }

                TapHandler {
                    id: expandTap
                    onTapped: {
                        quickToggles.expanded = !quickToggles.expanded;
                    }
                    gesturePolicy: TapHandler.ReleaseWithinBounds
                }
            }
        }

        Item {
            width: quickToggles.expanded ? icons.implicitWidth + Config.spaceMd : 0
            height: icons.implicitHeight
            clip: true

            Behavior on width {
                enabled: Config.animMs > 0
                NumberAnimation {
                    duration: quickToggles.expanded ? Config.animMs : Config.animMsClose
                    easing.type: quickToggles.expanded ? Easing.OutCubic : Easing.InCubic
                }
            }

            Row {
                id: icons
                x: Config.spaceMd
                spacing: Config.spaceSm

                Repeater {
                    model: [wifi, bluetooth, wled, idle, gamemode, oled]

                    ColorizedIcon {
                        required property var modelData
                        source: modelData.icon
                        color: iconHover.hovered ? Colors.md3.primary : modelData.active ? Colors.md3.tertiary : Colors.md3.on_surface

                        Behavior on color {
                            enabled: Config.animMs > 0
                            ColorAnimation {
                                duration: Config.animMs
                                easing.type: Easing.OutCubic
                            }
                        }

                        HoverHandler {
                            id: iconHover
                        }

                        TapHandler {
                            id: iconTap
                            gesturePolicy: TapHandler.ReleaseWithinBounds
                            onTapped: {
                                modelData.trigger();
                            }
                        }

                        TapHandler {
                            id: iconTapAlternate
                            gesturePolicy: TapHandler.ReleaseWithinBounds
                            acceptedButtons: Qt.RightButton
                            onTapped: {
                                modelData.triggerAlternate();
                            }
                        }
                    }
                }
            }
        }
    }
}
