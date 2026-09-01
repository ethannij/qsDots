import QtQuick
import Quickshell
import QtQuick.Layouts
import qs.modules.panel.modules
import qs.config
import qs.modules.elements
import qs.theme
import qs.services

Item {
    id: root

    implicitWidth: grid.implicitWidth
    implicitHeight: grid.implicitHeight

    property bool wifiMenuOpen: false

    property var widgets: [
        {
            "icon": Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/wifi/wifi_4.svg")),
            "title": "Wifi"
        },
        {
            "icon": Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/bluetooth/bluetooth_on.svg")),
            "title": "Bluetooth"
        },
        {
            "icon": Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/wled/wled.svg")),
            "title": "WLED",
            "action": WLED.toggle,
            "state": WLED.on
        },
        {
            "icon": Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/idle/idle.svg")),
            "title": "Idle Inhibitor",
            "cmd": ["qs", "ipc", "call", "inhibitIdleIpc", "toggleIdle"],
            "state": IdleInhibitor.inhibitIdle
        },
        {
            "icon": Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/gamemode/gamemode.svg")),
            "title": "Game Mode",
            "cmd": ["qs", "ipc", "call", "gamemodeIpc", "toggleGamemode"]
        }
    ]

    WifiMenu {
        id: wifiMenu
        visible: root.wifiMenuOpen
    }

    Grid {
        id: grid
        anchors.centerIn: parent
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.alignment: Qt.AlignCenter
        spacing: Config.spaceMd
        columns: 4
        rows: 2

        Repeater {
            model: root.widgets

            PillShape {
                id: widget

                required property var modelData

                implicitWidth: icon.implicitWidth + Config.spaceXl * 3
                implicitHeight: icon.implicitHeight + Config.spaceXl
                radius: height / 2
                color: hover.hovered ? Colors.md3.primary_container : Colors.md3.surface_variant

                HoverHandler {
                    id: hover
                    parent: widget
                    cursorShape: Qt.PointingHandCursor
                }

                TapHandler {
                    id: tap
                    parent: widget
                    gesturePolicy: TapHandler.ReleaseWithinBounds
                    onTapped: {
                        if (widget.modelData.cmd)
                            Quickshell.execDetached(widget.modelData.cmd);
                        else
                            widget.modelData.action();
                    }
                }

                ColorizedIcon {
                    id: icon
                    source: widget.modelData.icon
                    color: {
                        if (widget.modelData.title === "WLED")
                            return WLED.on ? Colors.md3.tertiary : Colors.md3.on_surface_variant;
                        if (widget.modelData.title === "Idle Inhibitor")
                            return IdleInhibitor.inhibitIdle ? Colors.md3.tertiary : Colors.md3.on_surface_variant;
                        if (widget.modelData.title === "Game Mode")
                            return Gamemode.active ? Colors.md3.tertiary : Colors.md3.on_surface_variant;
                        return Colors.md3.on_surface_variant;
                    }
                    size: Config.iconSize
                }
            }
        }
    }
}
