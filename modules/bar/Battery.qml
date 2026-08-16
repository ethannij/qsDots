import QtQuick
import QtQuick.Layouts
import qs.services
import qs.config
import qs.modules.elements

RowLayout {
    id: root
    spacing: Config.moduleGap

    Repeater {
        model: Power.devices

        PillShape {
            id: batteryItem
            required property var modelData
            visible: Power.isPeripheral(modelData)

            Text {
                id: powerIcon
                text: Power.deviceIcon(batteryItem.modelData)
                color: Power.batteryColor(batteryItem.modelData)
                font: StylizedFont.icon
            }
            Text {
                anchors.verticalCenter: parent.verticalCenter
                id: powerText
                text: " " +Math.round(batteryItem.modelData.percentage * 100) + "%"
                color: Power.batteryColor(batteryItem.modelData)
                font: StylizedFont.body
            }
            interactive: true
            HoverTip {
                anchorItem: batteryItem
                text: batteryItem.modelData.model
            }
        }
    }
}
