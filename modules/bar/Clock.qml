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
        font: StylizedFont.bold
        color: Colors.md3.primary
    }

    interactive: true
    
    HoverHandler {
        id: hover
        enabled: PillController.activeFace === "clock"
        cursorShape: Qt.PointingHandCursor
    }

    TapHandler {
        id: tap
        gesturePolicy: TapHandler.ReleaseWithinBounds
        onTapped: clockItem.showDate = !clockItem.showDate;
    }

}
