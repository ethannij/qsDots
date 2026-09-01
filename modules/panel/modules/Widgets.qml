import QtQuick
import Quickshell
import QtQuick.Layouts
import qs.modules.panel.modules
import qs.config
import qs.modules.elements
import qs.theme
import qs.services

Item {
    // Widget Grid Container, define widgets and behaviors here
    id: root

    // Set the size of the widget grid
    implicitWidth: grid.implicitWidth
    implicitHeight: grid.implicitHeight


    // To add widgets, first define the widget as a QtObject
    QtObject {
        id: wifi
        property url icon: Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/wifi/wifi_4.svg"))
        property bool active: false
        function trigger() {
        } // Placeholder for wifi functionality
    }

    QtObject {
        id: bluetooth
        property url icon: Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/bluetooth/bluetooth_on.svg"))
        property bool active: false
        function trigger() {
        } // Placeholder for bluetooth functionality
    }

    QtObject {
        id: wled
        property url icon: Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/wled/wled.svg"))
        property bool active: WLED.on
        function trigger() {
            WLED.toggle();
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

    Grid {
        id: grid
        anchors.centerIn: parent
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.alignment: Qt.AlignCenter
        spacing: Config.spaceMd
        columns: 4
        rows: 2

        // Add QtObjects to repeater to add to widget grid
        Repeater {
            model: [wifi, bluetooth, wled, idle, gamemode]

            QuickToggle {
                required property var modelData
                source: modelData.icon
                active: modelData.active
                onTapped: modelData.trigger()
            }
        }
    }
}
