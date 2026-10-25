//@ pragma UseQApplication

import QtQuick
import Quickshell
import QtQuick.Controls
import QtQuick.Effects
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
        width: 500
        height: 500
        visible: false
        title: "testWindow"

        Rectangle {
            anchors.fill: parent
            color: Colors.md3.surface
            Text {
                anchors.centerIn: parent
                color: Colors.md3.on_surface
                font: StylizedFont.title
                text: Audio.nickname
            }
        }
    }
}
