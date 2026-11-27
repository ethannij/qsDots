import Quickshell
import QtQuick
import qs.services
import qs.config
import qs.theme
import qs.modules.elements

IconButton {
    id: root
    source: ColorScheme.icon
    backgroundColor: buttonHover.hovered ? Colors.role.hover : "transparent"
    iconColor: buttonHover.hovered ? Colors.md3.primary : Colors.md3.on_surface

    // qs reload rebuilds this under the cursor and can synthesize a tap,
    // which advances dark → oled and then persists. Ignore taps briefly.
    property bool armed: false

    Timer {
        id: armTimer
        interval: 400
        onTriggered: root.armed = true
    }

    Connections {
        target: States
        function onReadyChanged() {
            if (!States.ready) {
                root.armed = false;
                return;
            }
            root.armed = false;
            armTimer.restart();
        }
    }

    Component.onCompleted: {
        if (States.ready)
            armTimer.start();
    }

    HoverHandler {
        id: buttonHover
        cursorShape: Qt.PointingHandCursor
    }

    TapHandler {
        id: buttonTap
        enabled: root.armed && States.ready
        onTapped: ColorScheme.cycleNext()
        gesturePolicy: TapHandler.ReleaseWithinBounds
    }
}
