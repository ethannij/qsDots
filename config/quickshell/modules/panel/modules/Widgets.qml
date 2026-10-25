import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.config
import qs.modules.elements
import qs.services
import qs.theme

Item {
    id: root

    implicitHeight: Config.iconSize + Config.spaceXl

    // To add widgets, first define the widget as a QtObject
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

    RowLayout {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: parent.height
        spacing: Config.spaceSm

        Repeater {
            id: quickToggleModel
            model: [wifi, bluetooth, wled, idle, gamemode, oled]

            QuickToggle {
                id: quickToggle
                required property var modelData
                Layout.fillWidth: true
                Layout.fillHeight: true
                visible: modelData.visible ?? true
                radius: height / 4
                source: modelData.icon
                active: modelData.active
                onTapped: modelData.trigger()
                onTappedAlternate: modelData.triggerAlternate()
            }
        }
    }
}
