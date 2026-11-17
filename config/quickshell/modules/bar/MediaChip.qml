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
                width: 40
                height: Config.barIconSize
                implicitWidth: width
                implicitHeight: height

                readonly property int barWidth: 2
                readonly property int barCount: 11
                readonly property real barSpacing: (width - barCount * barWidth) / (barCount - 1)
                property int step: 0

                Timer {
                    interval: 120
                    running: Media.isPlaying && root.visible && root.opacity > 0
                    repeat: true
                    onTriggered: wave.step = (wave.step + 1) % 8
                }

                Connections {
                    target: Media
                    function onIsPlayingChanged() {
                        if (!Media.isPlaying && wave.levels)
                            wave.levels = wave.rests ?? [];
                    }
                }

                Repeater {
                    model: wave.barCount

                    Rectangle {
                        required property int index
                        width: wave.barWidth
                        height: wave.height
                        radius: width / 2
                        x: index * (wave.barWidth + wave.barSpacing)
                        color: titleHover.hovered ? Colors.md3.primary : Colors.md3.secondary

                        transform: Scale {
                            origin.x: width / 2
                            origin.y: height / 2
                            yScale: {
                                const rest = 0.35 + (index % 3) * 0.15;
                                if (!Media.isPlaying)
                                    return rest;
                                const n = (wave.step + index) % 8;
                                return rest + (n < 4 ? n : 8 - n) * 0.12;
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

            /*Connections {
                target: Media
                function onProgressChanged() {
                    root.glide = Math.abs(Media.progress - root.shown) < 0.08;
                }
            }*/
        }
    }
}
