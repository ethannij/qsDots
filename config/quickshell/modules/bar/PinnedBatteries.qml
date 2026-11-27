import QtQuick
import Quickshell
import qs.config
import qs.modules.elements
import qs.services
import qs.theme

Item {
    id: root

    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight

    Row {
        id: row
        spacing: Config.spaceLg
        
        Repeater {
            model: Power.shownDevices

            Row {
                required property var modelData
                
                ColorizedIcon {
                    source: modelData.isLaptopBattery ? Power.batteryIcon(modelData) : modelData.charging ? Power.chargeIcon + Power.deviceIcon(modelData) : Power.deviceIcon(modelData)
                    color: hover.hovered ? Colors.md3.primary : Power.batteryColor(modelData)
                }

                Text {
                    text: Math.round(modelData.percentage * 100) + "%"
                    font: StylizedFont.body
                    color: hover.hovered ? Colors.md3.primary : Power.batteryColor(modelData)
                    anchors.verticalCenter: parent.verticalCenter
                }

                HoverHandler {
                    id: hover
                }

                TapHandler {
                    id: tap
                    acceptedButtons: Qt.RightButton
                   onTapped: {
                    const id = modelData.nativePath
                    if (States.pinnedBatteries.indexOf(id) !== -1)
                        States.togglePinned(id);
                   } 
                }
            }

        }

        Rectangle {
        id: divider

        height: Config.barHeight / 1.5
        width: 2
        radius: height / 2
        anchors.verticalCenter: parent.verticalCenter
        color: Colors.md3.surface_variant
    }


    }

    
}
