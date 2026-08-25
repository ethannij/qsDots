import QtQuick
import QtQuick.Controls
import qs.theme
import qs.config
import Quickshell.Widgets
import QtQuick.Effects

Item {
    id: root

    property alias value: slider.value
    property alias from: slider.from
    property alias to: slider.to
    property alias stepSize: slider.stepSize
    property alias xPos: track.x
    property alias yPos: track.y
    property alias orientation: slider.orientation
    property alias iconColor: iconColorization.colorizationColor

    property bool handleVisible: true
    property url imageURL: ""

    implicitWidth: slider.implicitWidth
    implicitHeight: slider.implicitHeight

    Slider {
        id: slider
        value: 0.5
        from: 0
        to: 1
        stepSize: 0.05
        orientation: Qt.Horizontal

        background: Rectangle {
            id: track
            x: slider.horizontal ? 0 : (slider.availableWidth - width) / 2
            y: slider.horizontal ? (slider.availableHeight - height) / 2 : 0
            implicitWidth: slider.horizontal ? 200 : 4
            implicitHeight: slider.horizontal ? 4 : 200
            color: Colors.md3.surface_variant
            border.color: Colors.md3.shadow
            radius: Math.min(width, height) / 2

            Rectangle {
                id: fill
                x: slider.horizontal ? 0 : (parent.width - width) / 2
                y: slider.horizontal ? (parent.height - height) / 2 : (handle.y - track.y)
                width: slider.horizontal ? (handle.x - track.x + handle.width) : handle.width
                height: slider.horizontal ? handle.height : (parent.height - (handle.y - track.y))
                radius: Math.min(width, height) / 2
                color: Colors.md3.primary
            }
        }

        handle: ClippingRectangle {
            id: handle
            x: slider.horizontal ? slider.visualPosition * (slider.availableWidth - width) : (slider.availableWidth - width) / 2
            y: slider.horizontal ? (slider.availableHeight - height) / 2 : slider.visualPosition * (slider.availableHeight - height)
            implicitWidth: 26
            implicitHeight: 26
            radius: height / 2
            color: "transparent"

            IconImage {
                id: handleImage
                source: root.imageURL
                anchors.centerIn: parent
                backer.fillMode: Image.PreserveAspectCrop
                implicitSize: 26
            }

            MultiEffect {
                id: iconColorization
                anchors.fill: handleImage
                source: handleImage
                colorization: 1
                colorizationColor: Colors.md3.on_primary

            }
        }
    }
}
