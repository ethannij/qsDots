import QtQuick
import qs.services
import qs.modules.pill

Item {
    id: root
    // activate when audio status changes
    Connections {
        target: Audio
        function onVolChanged() { root.show() }
        function onMutedChanged() { root.show() }
    }

    function show() {
        PillController.showFace("volume")
    }
}