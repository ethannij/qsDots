pragma Singleton
import Quickshell
import Quickshell.Networking
import QtQuick

// Exposes necessary wifi functions and properties
Singleton {
    id: root

    readonly property bool wifiEnabled: Networking.wifiEnabled
    property string pskSsid: "" // Used for psk prompt
    property string pskDraft: ""

    // This is pretty unique, but I didn't like seeing wifi_bad icon. I use my wifi as an access point for my lights, and ethernet for internet, so I provided a unique icon for that
    readonly property bool hotspotActive: {
        return [...Networking.devices.values].some(d => d.mode === WifiDeviceMode.AccessPoint);
    }

    // Defines icon to use based on state of wifi
    property url statusIcon: {
        if (hotspotActive)
            return root.iconUrl("tether");
        if (!wifiEnabled)
            return root.iconUrl("wifi_off");
        if (!connectedWifi)
            return root.iconUrl("wifi_bad");
        return root.signalIcon(connectedWifi.signalStrength);
    }

    // Return icon url based on state name
    function iconUrl(name) {
        return Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/wifi/" + name + ".svg"));
    }

    // Convert signal strength into a percentage
    function signalPercent(signalStrength) {
        const s = signalStrength ?? 0;
        return s <= 1 ? s * 100 : s;
    }

    // Return icon url based on signal strength percentage
    function signalIcon(signalStrength) {
        const pct = root.signalPercent(signalStrength);
        if (pct < 10)
            return root.iconUrl("wifi_0");
        if (pct < 25)
            return root.iconUrl("wifi_1");
        if (pct < 50)
            return root.iconUrl("wifi_2");
        if (pct < 75)
            return root.iconUrl("wifi_3");
        return root.iconUrl("wifi_4");
    }

    // Finds active wifi device
    readonly property var wirelessDevice: {
        const devices = [...Networking.devices.values];
        return devices.find(d => typeof d.scannerEnabled === "boolean") ?? devices.find(d => d.type === DeviceType.Wifi) ?? null;
    }

    // Exposes Connected Wifi Network
    readonly property var connectedWifi: {
        const wifi = root.wirelessDevice;
        if (!wifi)
            return null;
        return [...wifi.networks.values].find(n => n.connected) ?? null;
    }

    // Script Model that shows available networks and signal strength
    readonly property ScriptModel nearbyNetworks: ScriptModel {
        values: {
            const wifi = root.wirelessDevice;
            const live = wifi ? [...wifi.networks.values] : [];
            return live.map(n => ({
                        name: n.name,
                        signalStrength: n.signalStrength,
                        known: n.known,
                        connected: n.connected,
                        security: n.security,
                        net: n
                    })).sort((a, b) => {
                if (a.connected !== b.connected)
                    return b.connected - a.connected;
                return root.signalPercent(b.signalStrength) - root.signalPercent(a.signalStrength);
            });
        }
    }

    // Trigger a scan for wireless networks
    function kickScan() {
        if (root.wirelessDevice)
            root.wirelessDevice.scannerEnabled = true;
    }

    // Simple Wifi Toggle
    function toggleWifi() {
        Networking.wifiEnabled = !Networking.wifiEnabled;
    }

    // Disconnect from network
    function disconnectNetwork(net) {
        if (net)
            net.disconnect();
    }

    // Connects to network with option for password
    function connectTo(net, psk) {
        if (!net)
            return;
        if (root.wirelessDevice)
            root.wirelessDevice.scannerEnabled = false;
        if (psk)
            net.connectWithPsk(psk);
        else
            net.connect();
    }

    Component.onCompleted: root.kickScan() // Enable wifi scanning on load
    onWirelessDeviceChanged: root.kickScan() // When device changes, we lose scanning and nearby devices, this re-enables
}
