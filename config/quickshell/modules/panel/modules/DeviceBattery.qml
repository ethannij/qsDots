import QtQuick
import Quickshell.Services.UPower
import qs.config
import qs.theme
import qs.services
import qs.modules.elements

Item {
    id: root

    implicitHeight: row.implicitHeight
    implicitWidth: row.implicitWidth

    Row {
        id: row
        spacing: Config.controlPanelStatsSpacing

        Repeater {
            model: Power.devices

            Item {
                id: device
                required property var modelData

                implicitWidth: content.implicitWidth
                implicitHeight: content.implicitHeight
                z: pill.hovered ? 1 : 0

                readonly property bool pinned: States.pinnedBatteries.indexOf(modelData.nativePath) !== -1

                PillShape {
                    id: pill
                    interactive: true
                    anchors.centerIn: parent
                    width: parent.implicitWidth + Config.controlPanelStatsSpacing
                    height: parent.implicitHeight + Config.controlPanelStatsSpacing
                    color: hovered || device.pinned ? Colors.md3.surface_container_low : "transparent"
                    borderColor: device.pinned ? Colors.md3.primary : "transparent"

                    Row {
                        id: content

                        ColorizedIcon {
                            id: chargeIcon
                            visible: device.modelData.state === UPowerDeviceState.Charging
                            source: Power.chargeIcon
                            color: Power.batteryColor(device.modelData)
                        }

                        ColorizedIcon {
                            id: icon
                            source: Power.deviceIcon(device.modelData)
                            color: Power.batteryColor(device.modelData)
                        }

                        Text {
                            id: text
                            text: Math.round(device.modelData.percentage * 100) + "%"
                            font: StylizedFont.body
                            color: Colors.md3.on_surface
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    onTapped: States.togglePinned(device.modelData.nativePath)
                }

                HoverTip {
                    hoverText: Power.deviceLabel(device.modelData)
                    shown: pill.hovered
                    anchors.bottom: pill.top
                    anchors.horizontalCenter: pill.horizontalCenter
                    anchors.bottomMargin: Config.spaceSm
                    z: 10
                }
            }
        }
    }
}
