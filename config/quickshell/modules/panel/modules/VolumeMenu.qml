import QtQuick
import qs.services
import qs.modules.elements

DropdownMenu {
    text: Audio?.sink?.description ?? ""
    model: Audio.sinks
    textRole: "description"
    onSelected: modelData => Audio.setDefaultSink(modelData)
}
