import QtQuick
import Quickshell.Widgets
import QtQuick.Effects
import qs.config
import qs.services
import qs.theme
import qs.modules.elements

Item {
    id: root

    implicitWidth: slider.implicitWidth
    implicitHeight: slider.implicitHeight + tempIcon.implicitHeight + Config.spaceMd

    PillSlider {
        id: slider
        anchors.centerIn: parent
        orientation: Qt.Vertical
        from: Hyprsunset.gammaLowerLimit
        to: Hyprsunset.gammaUpperLimit
        value: Hyprsunset.gamma
        onValueChanged: Hyprsunset.setGamma(value)
        handleVisible: true
        imageURL: Hyprsunset.brightnessIconURL
        Text {
            id: text
            anchors.bottom: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins: 10
            text: Hyprsunset.gamma
            font: StylizedFont.body
            color: Colors.md3.on_surface
        }
        MouseArea {
            id: mouse
            anchors.fill: parent
            hoverEnabled: false
            cursorShape: Qt.PointingHandCursor
            z: -1

            onWheel: (wheel) =>{
                if (wheel.angleDelta.y > 0)
                    Hyprsunset.gammaUp();
                else if (wheel.angleDelta.y < 0)
                    Hyprsunset.gammaDown();
            }
        }
    }

    Rectangle {
        id: tempIcon
        anchors.top: slider.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: Config.spaceMd
        implicitWidth: icon.implicitWidth + Config.spaceMd
        implicitHeight: icon.implicitHeight + Config.spaceMd
        color: mouseIcon.containsMouse ? Colors.md3.surface_variant : "transparent"
        radius: height

        IconImage {
            id: icon
            anchors.centerIn: parent
            source: Hyprsunset.activeTemperatureIconURL
            backer.fillMode: Image.PreserveAspectCrop
            implicitSize: 30
        }
        MultiEffect {
            id: iconColorization
            anchors.fill: icon
            source: icon
            colorization: 1
            colorizationColor: Colors.md3.on_surface
        }
        MouseArea {
            id: mouseIcon
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                Hyprsunset.temperatureNext();
            }
        }
    }
}
