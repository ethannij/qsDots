import QtQuick
import Quickshell
import Quickshell.Services.UPower
import qs.theme
pragma Singleton

Singleton {
    id: root

    readonly property var devices_unfiltered: UPower.devices.values // Laptops can have trouble with UPower api as it exposes laptop battery & power supply
    readonly property var devices: devices_unfiltered.filter(d => d.isLaptopBattery !== true && d.powerSupply !== true) // Filter out laptop specific power devices
    readonly property var laptopBattery: devices_unfiltered.find(d => d.isLaptopBattery === true) // Specify laptop battery specifically for module, will ALWAYS be first in list
    // Icon to add if non-generic device is charging
    property url chargeIcon: Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/battery/charging/charging.svg"))

    // Determine icon for device
    function deviceIcon(devices) {
        switch (devices.type) {
        case UPowerDeviceType.Mouse:
            return Qt.resolvedUrl(Quickshell.shellPath("modules/img/devices/mouse.svg"));
        case UPowerDeviceType.Keyboard:
            return Qt.resolvedUrl(Quickshell.shellPath("modules/img/devices/keyboard.svg"));
        case UPowerDeviceType.GamingInput:
            return Qt.resolvedUrl(Quickshell.shellPath("modules/img/devices/controller_generic.svg"));
        case UPowerDeviceType.Headset:
            return Qt.resolvedUrl(Quickshell.shellPath("modules/img/devices/headset.svg"));
        case UPowerDeviceType.Speakers:
            return Qt.resolvedUrl(Quickshell.shellPath("modules/img/devices/speaker.svg"));
        case UPowerDeviceType.Headphones:
            return Qt.resolvedUrl(Quickshell.shellPath("modules/img/devices/headphones.svg"));
        case UPowerDeviceType.BluetoothGeneric:
            return batteryIcon(devices); // Use generic battery icon
        }
    }

    // Icon for battery, assuming no device match provided
    function batteryIcon(device) {
        const charging = device?.state === UPowerDeviceState.Charging;
        const level = Math.round(device?.percentage * 100);
        if (charging) {
            if (level < 20)
                return Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/battery/charging/battery_charging_empty.svg"));

            if (level < 30)
                return Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/battery/charging/battery_charging_20.svg"));

            if (level < 50)
                return Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/battery/charging/battery_charging_30.svg"));

            if (level < 60)
                return Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/battery/charging/battery_charging_50.svg"));

            if (level < 80)
                return Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/battery/charging/battery_charging_60.svg"));

            if (level < 90)
                return Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/battery/charging/battery_charging_80.svg"));

            return Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/battery/battery_full.svg"));
        }
        if (!charging) {
            if (level < 10)
                return Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/battery/battery_alert.svg"));

            if (level < 20)
                return Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/battery/battery_0.svg"));

            if (level < 30)
                return Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/battery/battery_1.svg"));

            if (level < 40)
                return Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/battery/battery_2.svg"));

            if (level < 50)
                return Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/battery/battery_3.svg"));

            if (level < 60)
                return Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/battery/battery_4.svg"));

            if (level < 70)
                return Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/battery/battery_5.svg"));

            if (level < 85)
                return Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/battery/battery_6.svg"));

            return Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/battery/battery_full.svg"));
        }
    }

    // Color change based on battery level
    function batteryColor(device) {
        const charging = device?.state === UPowerDeviceState.Charging;
        const level = Math.round(device?.percentage * 100);
        if (charging)
            return Colors.md3.secondary;

        if (level <= 15)
            return Colors.md3.error;

        if (level <= 30)
            return Colors.md3.tertiary;

        return Colors.md3.on_surface_variant;
    }
}
