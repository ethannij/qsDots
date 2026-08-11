pragma Singleton
import Quickshell
import QtQuick
import Quickshell.Services.UPower
import qs.theme


Singleton {
    id: root


    readonly property var devices: UPower.devices
    
    // Icon for battery, assuming no device match provided
    function batteryIcon(device) {
        const charging = device.state === UPowerDeviceState.Charging;
        const level = Math.round(device.percentage * 100);
        if (charging)
            return String.fromCodePoint(0xF0084); // 󰂄
        if (level >= 100)
            return String.fromCodePoint(0xF0079); // 󰁹
        if (level < 10)
            return String.fromCodePoint(0xF0083); // 󰂃
        return String.fromCodePoint(0xF007A + (Math.floor(level / 10) - 1)); // Variable icon based on level
    }

    // Color change based on battery level
    function batteryColor(device) {
        const charging = device.state === UPowerDeviceState.Charging;
        const level = Math.round(device.percentage * 100);
        if (charging)
            return Colors.md3.secondary;
        if (level <= 15)
            return Colors.md3.error;
        if (level <= 30)
            return Colors.md3.tertiary;
        return Colors.md3.on_surface_variant;
    }

    // Icon for device, takes priority over battery icon
    function deviceIcon(device) {
        if (device.type === UPowerDeviceType.Mouse)
            return String.fromCodePoint(0xF037D); // 󰍽
        if (device.type === UPowerDeviceType.GamingInput)
            return String.fromCodePoint(0xF11b) // 
        if (device.type === UPowerDeviceType.Keyboard)
            return String.fromCodePoint(0xF030C); // 󰌌
        if (device.type === UPowerDeviceType.Headset)
            return String.fromCodePoint(0xF02CB); // 󰋋
        return "";
    }

    // Determine if device is a peripheral
    function isPeripheral(device) {
        return device.type === UPowerDeviceType.Mouse
        || device.type === UPowerDeviceType.GamingInput
        || device.type === UPowerDeviceType.Keyboard
        || device.type === UPowerDeviceType.Headset;
    }
}