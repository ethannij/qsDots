//@ pragma UseQApplication

import QtQuick
import Quickshell
import qs.modules
import qs.modules.screenlock
import qs.services
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
}
