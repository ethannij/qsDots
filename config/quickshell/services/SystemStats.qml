pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property int cpuUsage: 0
    property int gpuUsage: 0
    property int memUsage: 0

    property int lastCpuTotal: 0
    property int lastCpuIdle: 0

    function sample() {
        parser.line = 0
        proc.running = false
        proc.running = true
    }

    Process {
        id: proc

        command: [
            "sh", "-c",
            "head -1 /proc/stat; " +
            "cat /sys/class/drm/card1/device/gpu_busy_percent 2>/dev/null || echo 0; " +
            "free | awk '/^Mem:/ {print $2,$3}'"
        ]

        stdout: SplitParser {
            id: parser
            property int line: 0

            onRead: data => {
                if (!data)
                    return

                const text = data.trim()
                if (!text)
                    return

                if (parser.line === 0) {
                    const p = text.split(/\s+/)
                    const idle = parseInt(p[4]) + parseInt(p[5])
                    const total = p.slice(1, 8).reduce((a, b) => a + parseInt(b), 0)
                    if (root.lastCpuTotal > 0 && total !== root.lastCpuTotal) {
                        root.cpuUsage = Math.round(100 * (1 - (idle - root.lastCpuIdle) / (total - root.lastCpuTotal)))
                    }
                    root.lastCpuTotal = total
                    root.lastCpuIdle = idle
                    parser.line = 1
                } else if (parser.line === 1) {
                    const n = parseInt(text)
                    root.gpuUsage = isNaN(n) ? 0 : n
                    parser.line = 2
                } else {
                    const parts = text.split(/\s+/)
                    const total = parseInt(parts[0]) || 1
                    const used = parseInt(parts[1]) || 0
                    root.memUsage = Math.round(100 * used / total)
                    parser.line = 0
                }
            }
        }

        Component.onCompleted: root.sample()
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: root.sample()
    }
}
