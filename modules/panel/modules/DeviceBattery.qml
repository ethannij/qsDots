import Quickshell
import QtQuick
import QtQuick.Layouts
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
        anchors.centerIn: parent
        spacing: Config.controlPanelStatsSpacing

        Repeater {
            model: Power.devices

            Row {
                required property var modelData

                ColorizedIcon {
                    id: chargeIcon
                    visible: parent.modelData.state === UPowerDeviceState.Charging
                    source: Power.chargeIcon
                    color: Power.batteryColor(parent.modelData)
                }

                ColorizedIcon {
                    id: icon
                    source: Power.deviceIcon(parent.modelData)
                    color: Power.batteryColor(parent.modelData)
                }

                Text {
                    id: text
                    text: Math.round(parent.modelData.percentage * 100) + "%"
                    font: StylizedFont.body
                    color: Colors.md3.on_surface
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }
}
