pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root
    property int gpuUsage: 0

    Process {
        id: gpuProc
        command: ["cat", "/sys/class/drm/card1/device/gpu_busy_percent"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                const n = parseInt(data.trim()) || 0
                root.gpuUsage = n
            }
        }
        Component.onCompleted: running = true
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            gpuProc.running = true
        }
    }
}