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
        spacing: Config.controlPanelStatsSpacing

        Repeater {
            model: SystemStats.stats

            Item {
                id: stat
                required property var modelData

                // Include pill chrome so the pin outline isn't clipped by the panel edge.
                implicitWidth: content.implicitWidth + Config.controlPanelStatsSpacing
                implicitHeight: content.implicitHeight + Config.controlPanelStatsSpacing
                z: pill.hovered ? 1 : 0

                readonly property bool pinned: States.pinnedSysUsage.indexOf(modelData.id) !== -1
                readonly property color accent: SystemStats.accentColor(modelData.colorKey)

                PillShape {
                    id: pill
                    interactive: true
                    anchors.centerIn: parent
                    width: parent.implicitWidth
                    height: parent.implicitHeight
                    color: hovered || stat.pinned ? Colors.role.hover : "transparent"
                    borderColor: stat.pinned ? Colors.md3.primary : "transparent"

                    Row {
                        id: content

                        ColorizedIcon {
                            source: stat.modelData.icon
                            color: stat.accent
                        }

                        Text {
                            text: {
                                void SystemStats.cpuText;
                                void SystemStats.memText;
                                void SystemStats.gpuText;
                                return SystemStats.displayText(stat.modelData.id);
                            }
                            font: StylizedFont.body
                            color: stat.accent
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    onTapped: States.togglePinnedSysUsage(stat.modelData.id)
                    onTappedAlternate: States.toggleSysUsageDetail(stat.modelData.id)
                }

                HoverTip {
                    hoverText: SystemStats.tipText(stat.modelData.id)
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
