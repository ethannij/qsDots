import Quickshell
import QtQuick
import qs.theme
import qs.config
import qs.services
import qs.modules.elements

Item {
    id: root
    implicitWidth: clockText.implicitWidth
    implicitHeight: clockText.implicitHeight
    Text {
        id: clockText
        text: Qt.formatDateTime(Time.date, Config.clockFormat)
        font {
            family: Config.fontFamilyPropo
            pointSize: Config.fontSize
            weight: Config.fontWeightBold
        }
        color: Colors.md3.primary
    }
    
}