import QtQuick
import Quickshell
import qs.config
import qs.modules.elements
import qs.services
import qs.theme

Item {
    id: root

    property color color: Colors.md3.tertiary

    PillShape {
        id: pill
        interactive: true

        anchors.centerIn: parent
        width: row.implicitWidth + Config.spaceMd * 2
        height: row.implicitHeight + Config.spaceMd
        color: hovered ? Colors.role.hover : "transparent"
        borderColor: "transparent"

        onTapped: Quickshell.execDetached(["xdg-open", "https://weather.com"])

        Behavior on color {
          enabled: Config.animMs > 0
          ColorAnimation {
            duration: Config.animMs
            easing.type: Easing[Config.animEasingInOut]
          }
        }
        

        Row {
            id: row
            spacing: Config.spaceSm

            ColorizedIcon {
                source: Weather.weatherIcon
                color: root.color
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                text: Weather.weatherTemperature
                font: StylizedFont.body
                color: root.color
                anchors.verticalCenter: parent.verticalCenter
            }

        }

    }

}
