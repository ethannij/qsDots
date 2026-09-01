import QtQuick
import QtQuick.Layouts
import qs.theme
import qs.services
import qs.config
import qs.modules.elements

Item {
    id: volumeItem

    implicitHeight: root.implicitHeight
    implicitWidth: root.implicitWidth
    property alias chrome: volumePill.chrome

    RowLayout {
        id: root
        spacing: Config.widgetSpacing

        PillShape {
            id: volumePill

            Text {
                text: Audio.icon
                color: Colors.md3.tertiary
                font: StylizedFont.icon
            }
            Text {
                anchors.verticalCenter: parent.verticalCenter
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
}
