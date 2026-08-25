pragma Singleton
import Quickshell
import Quickshell.Networking
import QtQuick

Singleton {
    readonly property var networkDevices: {
        return Networking.devices.values; // array of network device objects, needs filtering to get values
    }

    readonly property var wiredDevice: {
        return networkDevices.find(device => device.type === DeviceType.Wired); // shows first wired dev
    }

    readonly property var wirelessDevice: {
        return networkDevices.find(device => device.type === DeviceType.Wifi); // shows first wireless dev
    }

    readonly property var connectedWifi: {
        return wirelessDevice.networks.values.find(network => network.name !== null)
    }
}
