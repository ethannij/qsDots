import QtQuick
import Quickshell
import qs.config
import qs.modules.elements
import qs.services
import qs.theme

Item {
    id: root

    readonly property bool wifiShown: States.showWifiStatus
    readonly property bool bluetoothShown: States.showBluetoothStatus && Bluetooth.enabled
    readonly property bool gamemodeShown: States.showGamemodeStatus && Gamemode.active
    readonly property bool anyShown: wifiShown || bluetoothShown || gamemodeShown

    // Build only the icons that should show so Row spacing stays tight.
    readonly property var icons: {
        const list = [];
        if (wifiShown)
            list.push({
                "id": "wifi",
                "source": Networks.statusIcon,
                "color": Colors.md3.on_surface_variant
            });
        if (bluetoothShown)
            list.push({
                "id": "bluetooth",
                "source": Bluetooth.statusIcon,
                "color": Colors.md3.on_surface_variant
            });
        if (gamemodeShown)
            list.push({
                "id": "gamemode",
                "source": Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/gamemode/gamemode.svg")),
                "color": Colors.md3.tertiary
            });
        return list;
    }

    implicitWidth: anyShown ? row.implicitWidth : 0
    implicitHeight: Math.max(Config.barIconSize, iconsRow.implicitHeight)

    Row {
        id: row
        spacing: Config.spaceLg
        visible: root.anyShown
        anchors.verticalCenter: parent.verticalCenter

        Rectangle {
            height: Math.max(Config.barIconSize, iconsRow.height * 0.75)
            width: 2
            radius: height / 2
            anchors.verticalCenter: parent.verticalCenter
            color: Colors.role.chip
        }

        Row {
            id: iconsRow
            spacing: Config.spaceLg
            anchors.verticalCenter: parent.verticalCenter

            Repeater {
                model: root.icons

                ColorizedIcon {
                    required property var modelData
                    source: modelData.source
                    size: Config.barIconSize
                    color: hover.hovered ? Colors.md3.primary : modelData.color

                    HoverHandler {
                        id: hover
                    }
                }
            }
        }
    }
}
