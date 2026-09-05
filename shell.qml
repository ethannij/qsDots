//@ pragma UseQApplication
import Quickshell
import QtQuick
import qs.modules
import qs.services
import qs.modules.windows

ShellRoot {
    id: root
    ControlBar {}

    BluetoothMenu {}

    Component.onCompleted: {
        console.log()
    }
}
