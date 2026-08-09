pragma Singleton
import Quickshell
import QtQuick

Singleton {
    readonly property alias date: clock.date

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
}