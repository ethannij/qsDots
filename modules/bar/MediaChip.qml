import QtQuick
import qs.theme
import qs.config
import qs.modules.elements
import qs.services

PillShape {
    id: root

    property bool expanded: false

    onVisibleChanged: {
        if (!visible)
            root.expanded = false
    }

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

            Text {
                id: titleText
                text: "󰝚  " + (Media.title || "Nothing playing")
                elide: Text.ElideRight
                maximumLineCount: 1
                width: Math.min(implicitWidth, 1000)
                font: StylizedFont.body
                color: titleMouse.containsMouse ? Colors.md3.primary : Colors.md3.tertiary

                MouseArea {
                    id: titleMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.expanded = !root.expanded
                }
            }

            Item {
                id: navClip
                width: root.expanded ? Config.spaceMd + navRow.implicitWidth : 0
                height: Math.max(titleText.height, navRow.implicitHeight)
                clip: true

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
                height: 4
                radius: height / 2
                color: Colors.md3.surface_container_highest

                Rectangle {
                    id: fill
                    width: parent.width * Media.progress
                    height: parent.height
                    radius: parent.radius
                    color: Colors.md3.primary

                    Behavior on width {
                        enabled: !seekMouse.pressed
                        NumberAnimation {
                            duration: 80
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
                            Media.seekTo(mouse.x / width)
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
        color: btnMouse.containsMouse && available ? Colors.md3.primary : Colors.md3.tertiary
        opacity: available ? 1 : 0.35

        MouseArea {
            id: btnMouse
            anchors.fill: parent
            hoverEnabled: true
            enabled: btn.available
            cursorShape: btn.available ? Qt.PointingHandCursor : Qt.ArrowCursor
            onClicked: btn.clicked()
        }
    }
}
