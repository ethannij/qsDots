import QtQuick
import qs.services

Item {
    id: root

    property bool readySeen: false

    Connections {
        target: Audio
        function onReadyChanged() {
            if (Audio.ready)
                Qt.callLater(() => {
                    root.readySeen = true;
                });
        }
        function onVolChanged() {
            if (root.readySeen)
                root.show();
        }
        function onMutedChanged() {
            if (root.readySeen)
                root.show();
        }
    }

    Component.onCompleted: {
        if(Audio.ready)
            Qt.callLater(() => {
                root.readySeen = true;
            });
    }



    function show() {
        PillController.showFace("volume");
    }
}
