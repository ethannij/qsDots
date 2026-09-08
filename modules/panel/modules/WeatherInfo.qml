import QtQuick
import Quickshell
import qs.config
import qs.modules.elements
import qs.services
import qs.theme

Item {
    id: root

    property color color: Colors.md3.tertiary

    Row {
        spacing: Config.spaceSm
        anchors.centerIn: parent

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
