import QtQuick
import QtQuick.Layouts
import qs.theme
import qs.services
import qs.config
import qs.modules.elements

Item {

    implicitHeight: root.implicitHeight
    implicitWidth: root.implicitWidth

    RowLayout {
        id: root
        spacing: Config.widgetSpacing

            Text {
                text: Audio.icon
                color: Colors.md3.tertiary

                font {
                    family: Config.fontFamilyPropo
                    pointSize: Config.fontSizeIcon
                }
            }
            Text {
                text: {
                    if (!Audio.ready)
                        return " -";
                    if (Audio.muted)
                        return " Muted";
                    return " " + Audio.vol + "%";
                }

                color: Audio.muted ? Colors.md3.error : Colors.md3.tertiary

                font {
                    family: Config.fontFamilyPropo
                    pointSize: Config.fontSize
                }
            }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            Audio.toggleMute()
        }
        onWheel: wheel => {
            if (wheel.angleDelta.y > 0)
                Audio.volumeUp();
            else if (wheel.angleDelta.y < 0)
                Audio.volumeDown();
        }
    }
    HoverTip {
        anchorItem: root
        text: Audio.ready ?Audio.sink.description : ""
    }
}
