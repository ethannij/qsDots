import QtQuick
import qs.modules.elements
import qs.services
import qs.theme
import qs.config
import qs.modules.panel.modules

Item {
    id: root

    implicitWidth: slider.implicitWidth
    implicitHeight: slider.implicitHeight + text.implicitHeight + Config.spaceMd

    PillSlider {
        id: slider
        anchors.centerIn: parent
        value: Audio.vol / 100
        from: 0
        to: 1
        stepSize: 0.05
        orientation: Qt.Vertical
        onMoved: Audio.setVolume(value)        

        imageURL: root.iconURL

        MouseArea {
            id: mouse
            anchors.fill: parent
            hoverEnabled: false
            cursorShape: Qt.PointingHandCursor
            z: -1

            onWheel: (wheel) =>{
                if (wheel.angleDelta.y > 0)
                    Audio.volumeUp()
                else if (wheel.angleDelta.y < 0)
                    Audio.volumeDown()
            }
        }
    }

    property url iconURL: {
        if (Audio.muted)
            return Qt.resolvedUrl("../../img/audio/off.svg");
        if (Audio.vol === 0)
            return Qt.resolvedUrl("../../img/audio/mute.svg");
        if (Audio.vol < 67)
            return Qt.resolvedUrl("../../img/audio/low.svg");
        return Qt.resolvedUrl("../../img/audio/high.svg");
    }

    Text {
        id: text
        anchors.horizontalCenter: slider.horizontalCenter
        anchors.bottom: slider.top
        text: Audio.muted ? "Muted" : Math.round(slider.value * 100) + "%"
        color: Colors.md3.on_surface
        font: StylizedFont.body
    }

    VolumeMenu {
        anchors.top: slider.bottom
        anchors.horizontalCenter: slider.horizontalCenter
    }
}
