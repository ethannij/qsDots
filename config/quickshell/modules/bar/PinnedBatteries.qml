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

            Item {
                id: chip
                required property var modelData

                width: content.implicitWidth
                height: content.implicitHeight

                readonly property bool percentHidden: States.hiddenBatteryPercents.indexOf(modelData.nativePath) !== -1

                Row {
                    id: content
                    spacing: 0

                    ColorizedIcon {
                        source: chip.modelData.isLaptopBattery ? Power.batteryIcon(chip.modelData) : Power.deviceIcon(chip.modelData)
                        size: Config.barIconSize
                        color: hover.hovered ? Colors.md3.primary : Power.batteryColor(chip.modelData)
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        visible: !chip.percentHidden
                        text: Math.round(chip.modelData.percentage * 100) + "%"
                        font: StylizedFont.body
                        color: hover.hovered ? Colors.md3.primary : Power.batteryColor(chip.modelData)
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                HoverHandler {
                    id: hover
                }

                TapHandler {
                    acceptedButtons: Qt.LeftButton
                    gesturePolicy: TapHandler.ReleaseWithinBounds
                    onTapped: PillController.togglePanel()
                }

                TapHandler {
                    acceptedButtons: Qt.RightButton
                    gesturePolicy: TapHandler.ReleaseWithinBounds
                    onTapped: States.toggleBatteryPercent(chip.modelData.nativePath)
                }
            }
        }

        Rectangle {
            height: Math.max(Config.barIconSize, parent.height * 0.75)
            width: 2
            radius: height / 2
            anchors.verticalCenter: parent.verticalCenter
            color: Colors.role.chip
        }
    }
}
