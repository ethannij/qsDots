//@ pragma UseQApplication

import QtQuick
import Quickshell
import QtQuick.Controls
import qs.modules
import qs.modules.screenlock
import qs.modules.windows
import qs.modules.elements
import qs.services
import qs.config
import qs.theme

ShellRoot {
    id: root

    ControlBar {
        id: bar
        lockHeld: lock.locked && lock.covering
    }

    Lockscreen {
        id: lock
        barWidth: bar.pillWidth
        barHeight: bar.pillHeight
        clockShift: bar.clockShift
    }

    // Debug window
    Window {
        width: 300
        height: 300
        visible: false
        title: "testWindow"

        Rectangle {
            id: rect
            anchors.fill: parent
            color: Colors.md3.surface

            Button {
                anchors.centerIn: parent
                text: "Lock"
                onClicked: lock.lock()
            }
        }
    }
}
