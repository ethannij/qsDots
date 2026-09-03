pragma Singleton
import Quickshell
import Quickshell.Networking
import QtQuick

// Exposes necessary wifi functions and properties

Singleton {
    id: root

    readonly property bool wifiEnabled: Networking.wifiEnabled

    // Finds active wifi device
    readonly property var wirelessDevice: {
        const devices = [...Networking.devices.values];
        return devices.find(d => d.type === DeviceType.Wifi && d.mode === WifiDeviceMode.Station) ?? devices.find(d => d.type === DeviceType.Wifi) ?? null;
    }

    // Exposes Connected Wifi Network
    readonly property var connectedWifi: {
        const wifi = root.wirelessDevice;
        if (!wifi)
            return null;
        return [...wifi.networks.values].find(n => n.connected) ?? null;
    }

    property var seen: ({}) // Tracks seen networks by name

    // Script Model that shows available networks and signal strength
    readonly property ScriptModel nearbyNetworks: ScriptModel {
        values: {
            const wifi = root.wirelessDevice;
            const live = wifi ? [...wifi.networks.values] : [];
            const byName = {};
            for (const n of live)
                byName[n.name] = n;

            for (const n of live) {
                root.seen[n.name] = {
                    name: n.name,
                    signalStrength: n.signalStrength,
                    known: n.known,
                    connected: n.connected,
                    net: n
                };
            };

            for (const name of Object.keys(root.seen)) {
                if (!byName[name]) {
                    const prev = root.seen[name];
                    root.seen[name] = {
                        name: prev.name,
                        signalStrength: prev.signalStrength,
                        known: prev.known,
                        connected: false,
                        net: null
                    };
                }
            }

            return Object.values(root.seen).sort((a, b) => {
                if (a.connected !== b.connected)
                    return b.connected - a.connected;
                return b.signalSTrength - a.signalStrength;
            });
        }
    }

    function kickScan() {
        const wifi = root.wirelessDevice;
        if (!wifi)
            return
        if (!wifi.scannerEnabled)
            wifi.scannerEnabled = true;
    }

    function clearSeen() {
        root.seen = ({});
    }

    // Enables wifi scanning so we can actually see nearby networks
    function setScanning(on) {
        if (root.wirelessDevice)
            root.wirelessDevice.scannerEnabled = on;
    }

    // Simple Wifi Toggle
    function toggleWifi() {
        Networking.wifiEnabled = !Networking.wifiEnabled;
    }

    // Connects to network with option for password
    function connectTo(net, psk) {
        if (!net)
            return;
        if (psk)
            net.connectWithPsk(psk);
        else
            net.connect();
    }

    Component.onCompleted: root.setScanning(true) // Enable wifi scanning on load
    onWirelessDeviceChanged: root.setScanning(true) // When device changes, we lose scanning and nearby devices, this re-enables
}
