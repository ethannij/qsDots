import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import qs.theme
import qs.modules.elements
import qs.config

Item {
    id: workspaces
    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight

    RowLayout {
        id: row
        spacing: Config.widgetSpacing / 3

        Repeater {
            model: Config.workspaceCount

            PillShape {
                id: wsButton
                required property int index
                // Get functionality from Hyprland module
                property var ws: Hyprland.workspaces.values.find(w => w.id === (index + 1))
                property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
                property bool isHover: wsButton.containsMouse

                // Define font metrics for labels to prevent animation jittering
                FontMetrics {
                    id: wsFont
                    font.family: Config.fontFamilyPropo
                    font.pointSize: Config.fontSize
                    font.weight: Config.fontWeight
                }

                // Setting expeded widths to prevent animation jittering
                readonly property real labelW: wsFont.advanceWidth(String(index + 1))
                readonly property real collapsedW: labelW + Config.workspacePadH * 1.5
                readonly property real expandedW: labelW + Config.workspacePadH * 3

                Layout.preferredWidth: (isActive || isHover) ? expandedW : collapsedW
                Layout.preferredHeight: wsFont.height


                color: isActive ? Colors.md3.primary_container : isHover ? Colors.md3.secondary_container : Colors.md3.surface_variant

                Behavior on Layout.preferredWidth {
                    NumberAnimation {
                        duration: Config.animMs
                        easing.type: Easing.InOutCubic
                    }
                }

                Behavior on color {
                    ColorAnimation {
                        duration: Config.animMs
                        easing.type: Easing.InOutQuad
                    }
                }

                Text {
                    id: label
                    text: wsButton.index + 1
                    color: wsButton.isActive ? Colors.md3.on_primary_container : wsButton.isHover ? Colors.md3.on_secondary_container : (ws ? Colors.md3.tertiary : "transparent")

                    font {
                        family: Config.fontFamilyPropo
                        pointSize: Config.fontSize
                        weight: wsButton.isActive ? Config.fontWeightBold : Config.fontWeight
                    }
                }

            }
        }
    }
}
