import QtQuick
import Quickshell
import qs.theme
import qs.config
import qs.modules.elements
import qs.services

PillShape {
    id: root

    property bool expanded: false

    onVisibleChanged: {
        if (!visible)
            root.expanded = false;
    }

    anchors.horizontalCenter: parent.horizontalCenter

    Column {
        spacing: root.expanded ? Config.spaceXs : 0

        Behavior on spacing {
            NumberAnimation {
                duration: Config.animMs
                easing.type: Easing.InOutCubic
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
                        if (!Media.isPlaying)
                            wave.levels = wave.rests;
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
                }
                TapHandler {
                    id: titleTap
                    gesturePolicy: TapHandler.ReleaseWithinBounds
                    onTapped: root.expanded = !root.expanded
                }
            }

            Item {
                id: navClip
                width: root.expanded ? Config.spaceMd + navRow.implicitWidth : 0
                height: Math.max(wave.height, navRow.implicitHeight)
                clip: false

                Behavior on width {
                    NumberAnimation {
                        duration: Config.animMs
                        easing.type: Easing.InOutCubic
                    }
                }

                Row {
                    id: navRow
                    x: Config.spaceMd
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: Config.spaceSm

                    NavBtn {
                        text: "󰒮"
                        available: Media.canGoPrevious
                        onClicked: Media.previous()
                    }
                    NavBtn {
                        text: Media.isPlaying ? "󰏤" : "󰐊"
                        available: Media.canToggle
                        onClicked: Media.toggle()
                    }
                    NavBtn {
                        text: "󰒭"
                        available: Media.canGoNext
                        onClicked: Media.next()
                    }
                }
            }
        }

        Item {
            id: barWrap
            width: body.implicitWidth
            height: root.expanded ? 8 : 0
            clip: true

            Behavior on height {
                NumberAnimation {
                    duration: Config.animMs
                    easing.type: Easing.InOutCubic
                }
            }

            Rectangle {
                id: track
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 2
                height: 4
                width: parent.width * root.shown
                radius: height / 2
                color: Colors.md3.surface_container_highest

                Rectangle {
                    id: fill
                    width: parent.width * Media.progress
                    height: parent.height
                    radius: parent.radius
                    color: Colors.md3.primary

                    property real shown: Media.progress

                    Behavior on width {
                        enabled: root.glide && !seekMouse.pressed
                        NumberAnimation {
                            duration: Media.progressTick
                            easing.type: Easing.Linear
                        }
                    }

                    Behavior on shown {
                        enabled: PillController.panelOpen && root.glide && !seekMouse.pressed
                        NumberAnimation {
                            duration: Media.progressTick
                            easing.type: Easing.Linear
                        }
                    }
                }

                Rectangle {
                    id: headGlow
                    width: 14
                    height: 14
                    radius: 7
                    color: Colors.md3.primary
                    opacity: Media.isPlaying ? 0.28 : 0.12
                    x: fill.width - width / 2
                    anchors.verticalCenter: track.verticalCenter
                    visible: Media.length > 0
                }

                Rectangle {
                    id: head
                    width: 7
                    height: 7
                    radius: 3.5
                    color: Colors.md3.on_primary
                    border.color: Colors.md3.primary
                    border.width: 1
                    x: fill.width - width / 2
                    anchors.verticalCenter: track.verticalCenter
                    visible: Media.length > 0
                    scale: Media.isPlaying ? 1.08 : 1

                    Behavior on scale {
                        NumberAnimation {
                            duration: Config.animMs
                            easing.type: Easing.InOutCubic
                        }
                    }
                }

                MouseArea {
                    id: seekMouse
                    anchors.fill: parent
                    anchors.topMargin: -6
                    anchors.bottomMargin: -6
                    enabled: root.expanded && Media.canSeek
                    cursorShape: Media.canSeek ? Qt.PointingHandCursor : Qt.ArrowCursor
                    onClicked: mouse => Media.seekTo(mouse.x / width)
                    onPositionChanged: mouse => {
                        if (pressed)
                            Media.seekTo(mouse.x / width);
                    }
                }
            }
        }
    }

    component NavBtn: Text {
        id: btn
        property bool available: true
        signal clicked

        font: StylizedFont.icon
        color: btnTap && available ? Colors.md3.primary : Colors.md3.tertiary
        opacity: available ? 1 : 0.35

        HoverHandler {
            id: btnHover
            parent: btn
            cursorShape: btn.available ? Qt.PointingHandCursor : Qt.ArrowCursor
        }

        TapHandler {
            id: btnTap
            parent: btn
            gesturePolicy: TapHandler.ReleaseWithinBounds
            onTapped: btn.clicked()
        }
    }

    property bool glide: true

    Connections {
        target: Media
        function onProgressChanged() {
            root.glide = Math.abs(Media.progress - root.shown) < 0.08;
        }
    }
}
