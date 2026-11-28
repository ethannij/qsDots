import QtQuick
import Quickshell
import qs.theme
import qs.config
import qs.modules.elements
import qs.services

PillShape {
    id: root

    property bool expanded: false
    readonly property real waveWidth: wave.width
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
                // Continuous phase for the canned wave. Advanced on a low-rate
                // timer so motion stays smooth without per-vsync Behaviors.
                property real phase: 0

                Binding {
                    target: Cava
                    property: "bars"
                    value: wave.barCount
                }

                // Canned 20fps animation, sines themselves are continuous.
                Timer {
                    interval: 50
                    running: !States.liveMediaVisualizer && Media.isPlaying && root.visible && root.opacity > 0
                    repeat: true
                    onTriggered: wave.phase += 0.28
                }

                Repeater {
                    model: wave.barCount

                    Rectangle {
                        id: bar
                        required property int index
                        width: wave.barWidth
                        height: wave.barWidth + bar.level * (wave.height - wave.barWidth)
                        radius: wave.barWidth / 2
                        x: index * (wave.barWidth + wave.barSpacing)
                        y: (wave.height - height) / 2
                        color: titleHover.hovered ? Colors.role.accent : Colors.md3.secondary
                        antialiasing: true
                        smooth: true

                        // 0 = dot. 1 = full bar. No Behavior — both live and
                        // canned snap to their source rate (cava / timer).
                        property real level: {
                            if (!Media.isPlaying)
                                return 0;
                            if (States.liveMediaVisualizer) {
                                const v = Cava.levels[index];
                                return (v === undefined || v === null) ? 0 : v;
                            }
                            const t = wave.phase + index * 0.55;
                            return 0.35 + 0.65 * (0.5 + 0.5 * Math.sin(t));
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
