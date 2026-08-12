import QtQuick
import qs.services

Item {
    id: root

    Connections {
        target: Audio
        function onVolChanged() {root.show()}
        function onMutedChanged() {root.show()}
    }

    function show() {
        PillController.showFace("volume")
    }
}