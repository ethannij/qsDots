import Quickshell
import Quickshell.Wayland
import QtQuick
import qs.services
import qs.modules
import qs.theme
import qs.config

Item {
    id: root

    WlSessionLock {
        id: lock

        WlSessionLockSurface {
            id: surface
            Button {
                text: "Unlock"
                onClicked: lock.locked = false
            }
        }
    }

    lock.locked = true
}