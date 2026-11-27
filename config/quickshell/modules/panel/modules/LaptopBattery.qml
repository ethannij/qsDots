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

    readonly property bool pinned: States.pinnedBatteries.indexOf(laptopBattery.nativePath) !== -1

    PillShape {
        id: pill
        interactive: true
        anchors.centerIn: parent
        width: parent.implicitWidth + Config.controlPanelStatsSpacing
        height: parent.implicitHeight + Config.controlPanelStatsSpacing 
        color: hovered ? Colors.md3.surface_container_low : root.pinned ? Colors.md3.surface_container_low : "transparent"
        borderColor: root.pinned ? Colors.md3.primary : "transparent"
    
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
    onTapped: States.togglePinned(root.laptopBattery.nativePath)
    }

    HoverTip {
        id: hoverTip
        hoverText: Power.deviceLabel(root.laptopBattery)
        shown: pill.hovered
        anchors.bottom: pill.top
        anchors.horizontalCenter: pill.horizontalCenter
        anchors.bottomMargin: Config.spaceSm
        z: 10
    }

}
