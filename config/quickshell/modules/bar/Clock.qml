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
        font: StylizedFont.bold
        color: clockItem.hovered ? Colors.md3.primary : Colors.md3.on_surface_variant

        Behavior on color {
            ColorAnimation {
                duration: Config.animMs
                easing.type: Easing.InOutCubic
            }
        }
    }
    onTapped: clockItem.showDate = !clockItem.showDate
    onTappedAlternate: PillController.togglePanel();
}
