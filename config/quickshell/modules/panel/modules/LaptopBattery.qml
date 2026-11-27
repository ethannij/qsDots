import QtQuick
import Quickshell
import qs.config
import qs.modules.elements
import qs.services
import qs.theme

Item {
    id: root

    property var laptopBattery: Power.laptopBattery

    // Match SysUsage: layout size includes pill chrome so the row stays level.
    implicitWidth: content.implicitWidth + Config.controlPanelStatsSpacing
    implicitHeight: content.implicitHeight + Config.controlPanelStatsSpacing

    readonly property bool pinned: States.pinnedBatteries?.indexOf(laptopBattery?.nativePath) !== -1

    PillShape {
        id: pill
        interactive: true
        anchors.centerIn: parent
        width: parent.implicitWidth
        height: parent.implicitHeight
        color: hovered || root.pinned ? Colors.role.hover : "transparent"
        borderColor: root.pinned ? Colors.md3.primary : "transparent"

        Row {
            id: content

            ColorizedIcon {
                id: icon
                source: Power.batteryIcon(root.laptopBattery)
                color: Power.batteryColor(root.laptopBattery)
            }

            Text {
                id: text
                text: Math.round(root.laptopBattery?.percentage * 100) + "%"
                font: StylizedFont.body
                color: Power.batteryColor(root.laptopBattery)
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        onTapped: States.togglePinned(root.laptopBattery.nativePath)
    }

    HoverTip {
        hoverText: Power.deviceLabel(root.laptopBattery)
        shown: pill.hovered
        anchors.bottom: pill.top
        anchors.horizontalCenter: pill.horizontalCenter
        anchors.bottomMargin: Config.spaceSm
        z: 10
    }
}
