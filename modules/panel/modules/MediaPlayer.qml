import QtQuick
import QtQuick.Layouts
import qs.services
import qs.config
import qs.theme

Item {
    id: root
    implicitHeight: column.implicitHeight
    implicitWidth: column.implicitWidth

    Rectangle {
        anchors.fill: parent
        color: Colors.md3.surface_container
        radius: Config.radiusBox
        border.width: Config.borderWidth
        border.color: Colors.md3.outline_variant
    }

    ColumnLayout {
        id: column
        anchors.fill: parent
        anchors.margins: Config.spaceMd
        spacing: Config.spaceMd

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.maximumHeight: width

            Rectangle {
                anchors.centerIn: parent
                width: Math.min(parent.width, parent.height)
                height: width
                radius: Config.radiusBox
                color: Colors.md3.surface_container_highest
                clip: true

                Text {
                    anchors.centerIn: parent
                    visible: art.status !== Image.Ready
                    text: "󰝚"
                    font: StylizedFont.display
                    color: Colors.md3.on_surface_variant
                    opacity: 0.4
                }

                Image {
                    id: art
                    anchors.fill: parent
                    source: Media.artURL
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                    visible: status === Image.Ready
                }
            }
        }

        Column {
            Layout.fillWidth: true
            spacing: Config.spaceXs

            Text {
                width: parent.width
                text: Media.title || "Nothing playing"
                elide: Text.ElideRight
                maximumLineCount: 1
                font: StylizedFont.bold
                color: Colors.md3.on_surface
            }

            Text {
                width: parent.width
                text: Media.artist || Media.name || ""
                elide: Text.ElideRight
                maximumLineCount: 1
                visible: text.length > 0
                font: StylizedFont.tooltip
                color: Colors.md3.on_surface_variant
            }
        }

        Column {
            Layout.fillWidth: true
            spacing: Config.spaceXs

            Item {
                width: parent.width
                height: 8

                Rectangle {
                    id: track
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
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
                        width: 8
                        height: 8
                        radius: 4
                        color: Colors.md3.primary
                        x: fill.width - width / 2
                        anchors.verticalCenter: track.verticalCenter
                        visible: Media.length > 0
                    }
                }

                MouseArea {
                    id: seekMouse
                    anchors.fill: parent
                    enabled: Media.canSeek
                    cursorShape: Media.canSeek ? Qt.PointingHandCursor : Qt.ArrowCursor
                    onClicked: mouse => Media.seekTo(mouse.x / width)
                    onPositionChanged: mouse => {
                        if (pressed)
                            Media.seekTo(mouse.x / width)
                    }
                }
            }

            Item {
                width: parent.width
                height: posLabel.implicitHeight

                Text {
                    id: posLabel
                    anchors.left: parent.left
                    text: root.fmtTime(Media.position)
                    font: StylizedFont.tooltip
                    color: Colors.md3.on_surface_variant
                }

                Text {
                    anchors.right: parent.right
                    text: root.fmtTime(Media.length)
                    font: StylizedFont.tooltip
                    color: Colors.md3.on_surface_variant
                }
            }
        }

        Row {
            Layout.alignment: Qt.AlignHCenter
            spacing: Config.spaceLg

            NavBtn {
                text: "󰒮"
                available: Media.canGoPrevious
                onClicked: Media.previous()
            }
            NavBtn {
                text: Media.isPlaying ? "󰏤" : "󰐊"
                available: Media.canToggle
                font: StylizedFont.label
                onClicked: Media.toggle()
            }
            NavBtn {
                text: "󰒭"
                available: Media.canGoNext
                onClicked: Media.next()
            }
        }
    }

    function fmtTime(secs) {
        if (!secs || secs < 0)
            return "0:00"
        const m = Math.floor(secs / 60)
        const s = Math.floor(secs % 60)
        return m + ":" + String(s).padStart(2, "0")
    }

    component NavBtn: Text {
        id: btn
        property bool available: true
        signal clicked

        font: StylizedFont.icon
        color: btnMouse.containsMouse && available ? Colors.md3.primary : Colors.md3.on_surface
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
