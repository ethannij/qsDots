import QtQuick
import qs.theme
import qs.config
import qs.services
import qs.modules.elements

PillShape {
    id: clockItem
    property bool showDate: false

        Text {
            id: clockText
            text: clockItem.showDate ? Qt.formatDateTime(Time.date, Config.dateFormat) : Qt.formatDateTime(Time.date, Config.clockFormat)
            //text: clockItem.containsMouse ? "Hello" : "World"
            font {
                family: Config.fontFamilyPropo
                pointSize: Config.fontSize
                weight: Config.fontWeightBold
            }
            color: Colors.md3.primary
        }

    interactive: true
    cursorShape: Qt.PointingHandCursor
    onClicked: {
        clockItem.showDate = !clockItem.showDate;
    }
    
}
