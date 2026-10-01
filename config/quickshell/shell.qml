import QtQuick
//@ pragma UseQApplication
import Quickshell
import Quickshell.Wayland
import QtQuick.Controls
import Quickshell.Services.UPower
import qs.modules
import qs.modules.windows
import qs.modules.elements
import qs.services
import qs.config

ShellRoot {
    id: root

    ControlBar {
    }

    // Debug window
    Window {
        width: 300
        height: 300
        visible: false
        title: "testWindow"

        WlSessionLock {
        id: lock

        WlSessionLockSurface {
            Button {
                text: "Unlock"
                onClicked: lock.locked = false
            }
        }
    }

    

        Rectangle {
            anchors.fill: parent
            color: "black"

            Button {
                text: "lock"
                anchors.centerIn: parent
                onClicked: lock.locked = true
            }

        }

    }

}
