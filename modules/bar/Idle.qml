import QtQuick
import QtQuick.Effects
import Quickshell.Widgets
import qs.services
import qs.config
import qs.theme

    Item {
        id: indicactor
        implicitHeight: icon.implicitHeight
        implicitWidth: icon.implicitWidth

        IconImage {
            id: icon
            anchors.centerIn: parent
            source: Qt.resolvedUrl("../../modules/img/widgets/idle/idle.svg")
            backer.fillMode: Image.PreserveAspectCrop
            implicitSize: Config.barHeight * 0.5
            visible: false
        }

        MultiEffect {
            id: iconColorization
            anchors.fill: icon
            source: icon
            colorization: 1
            colorizationColor: Colors.md3.tertiary
        }
    }
