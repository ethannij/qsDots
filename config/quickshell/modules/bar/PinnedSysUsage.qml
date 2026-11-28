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

    // Percent capped to 99% to avoid having to reserve space for a 3rd digit and mess up spacing.
    TextMetrics {
        id: percentMetrics
        font: StylizedFont.body
        text: "99%"
    }

    Row {
        id: row
        spacing: Config.spaceLg

        Repeater {
            model: SystemStats.shownStats

            Item {
                id: chip
                required property var modelData

                width: content.implicitWidth
                height: content.implicitHeight

                readonly property color accent: SystemStats.accentColor(modelData.colorKey)

                Row {
                    id: content
                    spacing: 0

                    ColorizedIcon {
                        source: chip.modelData.icon
                        size: Config.barIconSize
                        color: hover.hovered ? Colors.md3.primary : chip.accent
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        text: {
                            void SystemStats.cpuText;
                            void SystemStats.memText;
                            void SystemStats.gpuText;
                            return SystemStats.displayText(chip.modelData.id);
                        }
                        font: StylizedFont.body
                        color: hover.hovered ? Colors.md3.primary : chip.accent
                        anchors.verticalCenter: parent.verticalCenter
                        width: Math.max(percentMetrics.width, contentWidth)
                    }
                }

                HoverHandler {
                    id: hover
                }

                TapHandler {
                    acceptedButtons: Qt.RightButton
                    gesturePolicy: TapHandler.ReleaseWithinBounds
                    onTapped: States.toggleSysUsageDetail(chip.modelData.id)
                }
            }
        }

        Rectangle {
            visible: SystemStats.shownStats.length > 0
            height: Math.max(Config.barIconSize, parent.height * 0.75)
            width: visible ? 2 : 0
            radius: height / 2
            anchors.verticalCenter: parent.verticalCenter
            color: Colors.role.chip
        }
    }
}
