pragma Singleton
import QtQuick
import Quickshell
import qs.config

Singleton {
    id: root
    property string activeFace: "clock"
    
    Timer {
        id: faceTimer
        interval: Config.ttlMs
        repeat: false
        onTriggered: { root.activeFace = "clock" }
    }

    function showFace(name) {
        activeFace = name
        if (name === "clock")
            faceTimer.stop()
        else
            faceTimer.restart()
    }

    function dismiss() {
        activeFace = "clock"
        faceTimer.stop()
    }
}