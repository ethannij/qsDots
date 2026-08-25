import QtQuick
import Quickshell
import qs.modules.elements
import qs.services
import qs.theme
import qs.config

Item {
    id: root

    implicitWidth: Math.max(slider.implicitWidth, text.implicitWidth)
    implicitHeight: slider.implicitHeight + text.implicitHeight

    PillSlider {
        id: slider
        value: Audio.vol / 100
        from: 0
        to: 1
        stepSize: 0.05
        orientation: Qt.Vertical

        onValueChanged: Audio.setVolume(value)

        imageURL: root.iconURL
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
}
