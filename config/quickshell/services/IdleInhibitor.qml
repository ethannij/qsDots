pragma Singleton

import Quickshell
import Quickshell.Wayland as Wayland
import QtQuick
import Quickshell.Io

Singleton {
    id: root
    property bool inhibitIdle: false

    Wayland.IdleInhibitor {
        id: inhibitor
        enabled: root.inhibitIdle
        window: dummy
    }

    PanelWindow {
        id: dummy
        implicitHeight: 1
        implicitWidth: 1
        color: "transparent"
        mask: Region {}
    }

    IpcHandler {
        id: ipc
        target: "inhibitIdleIpc"
        function toggleIdle(): void {
            root.inhibitIdle = !root.inhibitIdle;
        }
    }
}