import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.config
import qs.modules.elements
import qs.services
import qs.theme

Item {
    id: root

    readonly property var stats: [{
        "icon": Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/system/cpu.svg")),
        "color": Colors.md3.primary,
        "key": "cpuUsage"
    }, {
        "icon": Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/system/memory.svg")),
        "color": Colors.md3.secondary,
        "key": "memUsage"
    }, {
        "icon": Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/system/gpu.svg")),
        "color": Colors.md3.tertiary,
        "key": "gpuUsage"
    }]

    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight

    PillShape {
        id: pill

        anchors.centerIn: parent
        width: row.implicitWidth + Config.controlPanelStatsSpacing
        height: row.implicitHeight + Config.controlPanelStatsSpacing 
        color: Colors.md3.surface_container_low

        Row {
            id: row

            spacing: Config.controlPanelStatsSpacing

            Repeater {
                model: root.stats

                Row {
                    required property var modelData

                    ColorizedIcon {
                        id: icon

                        source: parent.modelData.icon
                        color: parent.modelData.color
                    }

                    Text {
                        id: text

                        text: SystemStats[parent.modelData.key] + "%"
                        font: StylizedFont.body
                        color: parent.modelData.color
                        anchors.verticalCenter: parent.verticalCenter
                    }

                }

            }

        }

    }

}
