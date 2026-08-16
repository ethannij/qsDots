import QtQuick
import Quickshell
import qs.modules
import qs.modules.bar
import qs.modules.behaviors
import qs.modules.panel
import qs.services
pragma Singleton

// Control which face is active in pill
Singleton {
    id: handler

    property string activeFace: "clock"
    property string defaultFace: "clock"
    property string previousFace: "clock"
    property string panelFace: ""
    property string activeSession: ""
    property bool pinned: false
    property bool panelOpen: false

    function showFace(name) {
        if (panelOpen)
            return ;

        if (name === "clock") {
            faceTimer.stop();
            activeFace = name;
            return ;
        }
        previousFace = activeFace;
        activeFace = name;
        if (panelOpen || pinned)
            faceTimer.stop();
        else
            faceTimer.restart();
    }

    function dismiss() {
        if (panelOpen || pinned)
            return ;

        activeFace = "clock";
        faceTimer.stop();
    }

    function forceDismiss() {
        faceTimer.stop()
        activeFace = "clock"
        panelOpen = false
    }

    onPinnedChanged: {
        if (panelOpen || pinned)
            faceTimer.stop();
        else if (activeFace !== defaultFace)
            faceTimer.restart();
    }

    function togglePanel() {
        if (panelOpen) {
            closePanel();
        }
        else { 
            showPanel();
        }
    }

    function showPanel() {
        panelOpen = true
        faceTimer.stop()
    }

    function closePanel() {
        panelOpen = false
    }

    Timer {
        id: faceTimer

        interval: 2000
        repeat: false
        onTriggered: {
            if (handler.panelOpen || handler.pinned)
                return ;

            handler.dismiss();
        }
    }

}
