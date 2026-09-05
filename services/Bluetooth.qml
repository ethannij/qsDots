pragma Singleton

import Quickshell
import Quickshell.Bluetooth as QsBt // Qt also provides a Bluetooth module
import QtQuick

Singleton {
    id: root

    // Exposing default device properties, not sure when you'd need to access another Bluetooth device

    readonly property var defaultAdapter: QsBt.Bluetooth.defaultAdapter // Default adapter, target for everything

    property var devices: defaultAdapter?.devices ?? undefined // All devices on the default adapter

    property bool enabled: defaultAdapter?.enabled ?? false // Whether Bluetooth is enabled

    // Defines icon to use around system based on state of Bluetooth
    property url statusIcon: {
        if (defaultAdapter?.discovering)
            return Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/bluetooth/bluetooth_search.svg"));
        else
            switch (enabled) {
            case true:
                return Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/bluetooth/bluetooth_on.svg"));
            case false:
                return Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/bluetooth/bluetooth_off.svg"));
            default:
                return Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/bluetooth/bluetooth_off.svg"));
            }
    }

    // Pair a device, unpair if paired, pair and trust if not paired. Trust is required for some devices to connect.
    function pairDevice(device) {
        if (!device)
            return;
        if (device.paired) {
            device.forget();
            return;
        }
        device.pair();
        device.trusted = true;
    }

    // Connect a device, disconnect if connected, pair and trust if not paired.
    function connectDevice(device) {
        if (!device)
            return;
        if (device.connected) {
            device.connected = false;
            return;
        }
        if (!device.paired) {
            device.pair();
            return;
        }
        device.trusted = true;
        device.connected = true;
    }
}
