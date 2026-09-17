pragma Singleton
import Quickshell
import Quickshell.Hyprland
import QtQuick

Singleton {
    id: root
    
    property var monitors: Hyprland.monitors
    property var activeMonitor: Hyprland.focusedMonitor
    property list<string> monitorNames: monitors.map(monitor => monitor.id)


}