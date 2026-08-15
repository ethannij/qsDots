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
    readonly property var stickyFaces: ["controlpanel"]
    readonly property bool sticky: stickyFaces.indexOf(activeFace) !== -1
    property bool panelOpen: false

    function showFace(name) {
        if (panelOpen || sticky && stickyFaces.indexOf(name) === -1)
            return ;

        if (name === "clock") {
            faceTimer.stop();
            activeFace = name;
            return ;
        }
        previousFace = activeFace;
        activeFace = name;
        if (panelOpen || pinned || stickyFaces.indexOf(name) === -1)
            faceTimer.stop();
        else
            faceTimer.restart();
    }

    function dismiss() {
        if (panelOpen || pinned || sticky)
            return ;

        activeFace = "clock";
        faceTimer.stop();
    }

    function forceDismiss() {
        faceTimer.stop()
        activeFace = "clock"
    }

    onPinnedChanged: {
        if (panelOpen || pinned || sticky)
            faceTimer.stop();
        else if (activeFace !== defaultFace)
            faceTimer.restart();
    }

    Timer {
        id: faceTimer

        interval: 2000
        repeat: false
        onTriggered: {
            if (handler.panelOpen || handler.sticky || handler.pinned)
                return ;

            handler.dismiss();
        }
    }

}
