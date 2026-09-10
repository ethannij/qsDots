import QtQuick
import Quickshell
import qs.config
import qs.modules.elements
import qs.services
import qs.theme

Item {
    id: root

    property var laptopBattery: Power.laptopBattery // Battery device for laptop

    implicitWidth: icon.implicitWidth + text.implicitWidth
    implicitHeight: Math.max(icon.implicitHeight, text.implicitHeight)

    PillShape {
        id: pill
        anchors.centerIn: parent
        width: parent.implicitWidth + Config.controlPanelStatsSpacing
        height: parent.implicitHeight + Config.controlPanelStatsSpacing 
        color: Colors.md3.surface_container_low
    
    Row {

        ColorizedIcon {
            id: icon

            source: Power.batteryIcon(laptopBattery)
            color: Power.batteryColor(laptopBattery)
        }

        Text {
            id: text

            text: Math.round(laptopBattery?.percentage * 100) + "%"
            font: StylizedFont.body
            color: Power.batteryColor(laptopBattery)
            anchors.verticalCenter: parent.verticalCenter
        }

    }
    }

}
