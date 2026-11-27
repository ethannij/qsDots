import QtQuick
import Quickshell
import qs.theme
import qs.config
import qs.modules.elements
import qs.services

PillShape {
    id: root

    property bool expanded: false
    cursorShape: Qt.ArrowCursor

    onVisibleChanged: {
        if (!visible)
            root.expanded = false;
    }

    // Cava only when the live visualizer is on and the chip is actually playing.
    Binding {
        target: Cava
        property: "wanted"
        value: States.liveMediaVisualizer && root.visible && root.opacity > 0 && Media.isPlaying
    }

    Column {
        spacing: root.expanded ? Config.spaceXs : 0

        Behavior on spacing {
            NumberAnimation {
                duration: Config.animMs
                easing.type: Easing[Config.animEasing]
            }
        }

        Row {
            id: body
            spacing: 0

            Item {
                id: wave
                width: 44
                height: Config.barIconSize
                implicitWidth: width
                implicitHeight: height

                // 2px circles read as squares on most displays; 3px + AA looks round.
                readonly property int barWidth: 3
                readonly property int barCount: 11
                readonly property real barSpacing: (width - barCount * barWidth) / (barCount - 1)
                property int step: 0

                Binding {
                    target: Cava
                    property: "bars"
                    value: wave.barCount
                }

                // Old canned bounce when live cava is disabled.
                Timer {
                    interval: 120
                    running: !States.liveMediaVisualizer && Media.isPlaying && root.visible && root.opacity > 0
                    repeat: true
                    onTriggered: wave.step = (wave.step + 1) % 8
                }

                Repeater {
                    model: wave.barCount

                    Rectangle {
                        id: bar
                        required property int index
                        width: wave.barWidth
                        // Paused: height == width -> circle. Playing: grow toward full height.
                        height: wave.barWidth + bar.level * (wave.height - wave.barWidth)
                        radius: height / 2
                        x: index * (wave.barWidth + wave.barSpacing)
                        y: (wave.height - height) / 2
                        color: titleHover.hovered ? Colors.role.accent : Colors.md3.secondary
                        antialiasing: true
                        smooth: true

                        // 0 = dot. 1 = full bar.
                        property real level: {
                            if (!Media.isPlaying)
                                return 0;
                            if (States.liveMediaVisualizer) {
                                const v = Cava.levels[index];
                                return (v === undefined || v === null) ? 0 : v;
                            }
                            const n = (wave.step + index) % 8;
                            const bounce = (n < 4 ? n : 8 - n) / 4;
                            return 0.35 + bounce * 0.65;
                        }

                        Behavior on level {
                            NumberAnimation {
                                duration: States.liveMediaVisualizer ? 80 : 100
                                easing.type: Easing.OutCubic
                            }
                        }
                    }
                }

                HoverHandler {
                    id: titleHover
                    cursorShape: Qt.ArrowCursor
                }
                TapHandler {
                    id: titleTap
                    gesturePolicy: TapHandler.ReleaseWithinBounds
                    onTapped: PillController.togglePanel()
                }
            }
        }
    }
}
