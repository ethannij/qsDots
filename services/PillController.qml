pragma Singleton
import qs.modules.bar
import qs.modules.behaviors
import Quickshell
import QtQuick


// Control which face is active in pill
Singleton {
    id: handler

    property string activeFace: "clock"
    property string defaultFace: "clock"
    property string previousFace: "clock"


    Timer {
        id: faceTimer
        interval: 2000
        repeat: false
        onTriggered: { handler.showFace(handler.defaultFace)}
    }

    function showFace(name) {
        if (name === "clock") 
            faceTimer.stop()
         else 
            faceTimer.restart()
            previousFace = activeFace
            activeFace = name
       
    }

    function dismiss() {
        activeFace = "clock"
        faceTimer.stop()
    }
}