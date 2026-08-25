pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import qs.theme
import qs.modules.elements
import qs.config

PillShape {
    id: workspaces

    // Width tween fights MorphPill shell sizing; keep off when hosted as a face.
    property bool animateWidths: true

    RowLayout {
        spacing: Config.workspaceItemGap

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
                    font: StylizedFont.body
                }

                // Setting expanded widths to prevent animation jittering
                readonly property real labelW: wsFont.advanceWidth(String(index + 1))
                readonly property real collapsedW: labelW + Config.workspaceCollapsedExtraWidth
                readonly property real expandedW: labelW + Config.workspaceExpandedExtraWidth

                Layout.preferredWidth: (isActive || isHover) ? expandedW : collapsedW
                Layout.preferredHeight: wsFont.height


                color: isActive ? Colors.md3.primary_container : isHover ? Colors.md3.secondary_container : Colors.md3.surface_variant

                Behavior on Layout.preferredWidth {
                    enabled: workspaces.animateWidths
                    NumberAnimation {
                        duration: Config.animMs
                        easing.type: Easing.InOutCubic
                    }
                }

                Behavior on color {
                    ColorAnimation {
                        duration: Config.animMs
                        easing.type: Easing.InOutCubic
                    }
                }

                

                Text {
                    id: label
                    text: wsButton.index + 1
                    color: wsButton.isActive ? Colors.md3.on_primary_container : wsButton.isHover ? Colors.md3.on_secondary_container : ws ?Colors.md3.tertiary : Colors.md3.tertiary

                    opacity: wsButton.isActive ? 1 : wsButton.isHover ? 1 : (ws ? 1 : 0)
                    font: wsButton.isActive ? StylizedFont.bold : StylizedFont.body

                    Behavior on opacity {
                    NumberAnimation {
                        duration: Config.animMs
                        easing.type: Easing.InOutCubic
                    }
                }
                }

                interactive: true
                onClicked: Hyprland.dispatch("hl.dsp.focus({ workspace = " + (index + 1) + " })")
                onWheel: wheel => {
                    if (wheel.angleDelta.y > 0)
                        Hyprland.dispatch("hl.dsp.focus({ workspace = 'e+1'})");
                    else if (wheel.angleDelta.y < 0)
                        Hyprland.dispatch("hl.dsp.focus({ workspace = 'e-1' })");
                }
            }
        }
    }
}
