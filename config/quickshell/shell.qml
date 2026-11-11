//@ pragma UseQApplication

import QtQuick
import Quickshell
import qs.modules
import qs.modules.screenlock
import qs.services
import qs.config
import qs.theme
import QtQuick.Controls
import qs.modules.windows

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

    SettingsWindow {
        id: settingsWindow
    }

    // Debug window
    Window {
        width: 500
        height: 500
        visible: false
        title: "testWindow"

        Rectangle {
            id: rect
            anchors.fill: parent
            color: Colors.md3.surface

            Text {
                text: PillController.settingsWindowOpen
                font: StylizedFont.title
                color: Colors.md3.on_surface
                anchors.centerIn: parent
            }
        }
    }
}
