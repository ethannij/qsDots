import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import QtQuick.Effects
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
            "icon": Qt.resolvedUrl("../../img/widgets/wifi/wifi_4.svg"),
            "title": "Wifi"
        },
        {
            "icon": Qt.resolvedUrl("../../img/widgets/bluetooth/bluetooth_on.svg"),
            "title": "Bluetooth"
        },
        {
            "icon": Qt.resolvedUrl("../../img/widgets/wled/wled.svg"),
            "title": "WLED",
            "action": WLED.toggle,
            "state": WLED.on
        },
        {
            "icon": Qt.resolvedUrl("../../img/widgets/idle/idle.svg"),
            "title": "Idle Inhibitor",
            "cmd": ["qs", "ipc", "call", "inhibitIdleIpc", "toggleIdle"],
            "state": IdleInhibitor.inhibitIdle
        },
        {
            "icon": Qt.resolvedUrl("../../img/widgets/gamemode/gamemode.svg"),
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

                interactive: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (modelData.cmd)
                        Quickshell.execDetached(modelData.cmd);
                    else
                        modelData.action();
                }
                color: mouse.containsMouse ? Colors.md3.primary_container : Colors.md3.surface_variant

                Item {
                    implicitWidth: icon.implicitSize
                    implicitHeight: icon.implicitSize

                    IconImage {
                        id: icon
                        anchors.centerIn: parent
                        source: widget.modelData.icon
                        backer.fillMode: Image.PreserveAspectCrop
                        implicitSize: 30
                        visible: false
                    }
                    MultiEffect {
                        id: iconColorization
                        anchors.fill: icon
                        source: icon
                        colorizationColor: {
                            if (widget.modelData.title === "WLED")
                                return WLED.on ? Colors.md3.tertiary : Colors.md3.on_surface_variant;
                            if (widget.modelData.title === "Idle Inhibitor")
                                return IdleInhibitor.inhibitIdle ? Colors.md3.tertiary : Colors.md3.on_surface_variant;
                            if (widget.modelData.title === "Game Mode")
                                return Gamemode.active ? Colors.md3.tertiary : Colors.md3.on_surface_variant;
                            return Colors.md3.on_surface_variant;
                        }
                        colorization: 1
                    }
                }
            }
        }
    }
}
