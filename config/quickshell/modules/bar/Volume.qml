import QtQuick
import QtQuick.Layouts
import qs.theme
import qs.services
import qs.config
import qs.modules.elements

Item {
    id: volumeItem

    implicitHeight: Config.barHeight
    implicitWidth: root.implicitWidth
    property alias chrome: root.chrome

    PillShape {
        id: root

        anchors.fill: parent
        implicitWidth: row.implicitWidth
        implicitHeight: row.implicitHeight

        RowLayout {
            id: row
            spacing: Config.spaceSm
            anchors.margins: Config.spaceSm

            ColorizedIcon {
                id: icon
                Layout.alignment: Qt.AlignVCenter
                source: Audio.icon
                color: Colors.md3.tertiary
            }

            PillSlider {
                id: slider
                Layout.alignment: Qt.AlignVCenter
                Layout.fillWidth: false

                to: Config.volumeMax
                from: Config.volumeMin
                value: Audio.vol / 100
                stepSize: Config.volumeStep
                onMoved: Audio.setVolume(value)
                sliderSize: text.height / 2
                backgroundColor: Colors.md3.surface_variant
                borderColor: Colors.md3.shadow
                fillColor: Colors.md3.tertiary
                iconColor: Colors.md3.on_tertiary

            }

            Text {
                id: text
                text: {
                    if (!Audio.ready)
                        return " -";
                    if (Audio.muted)
                        return " Muted";
                    return " " + Audio.vol + "%";
                }

                color: Audio.muted ? Colors.md3.error : Colors.md3.tertiary
                font: StylizedFont.body
            }
        }
        onTapped: Audio.toggleMute()

        WheelHandler {
            id: wheel
            acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
            onWheel: event => {
                if (event.angleDelta.y > 0)
                    Audio.volumeUp();
                if (event.angleDelta.y < 0)
                    Audio.volumeDown();
                event.accepted = true;
            }
        }
    }
}
