pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick
import qs.services
import qs.theme

Singleton {
    id: root

    property int cpuUsage: 0
    property int gpuUsage: 0
    property int memUsage: 0
    property int memTotalKiB: 0
    property int memUsedKiB: 0
    property int cpuTemp: 0
    property int gpuTemp: 0

    property int lastCpuTotal: 0
    property int lastCpuIdle: 0

    readonly property var stats: [{
            "id": "cpu",
            "label": "CPU",
            "icon": Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/system/cpu.svg")),
            "colorKey": "primary"
        }, {
            "id": "mem",
            "label": "Memory",
            "icon": Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/system/memory.svg")),
            "colorKey": "secondary"
        }, {
            "id": "gpu",
            "label": "GPU",
            "icon": Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/system/gpu.svg")),
            "colorKey": "tertiary"
        }]

    // Always CPU → RAM → GPU regardless of pin order.
    readonly property var shownStats: stats.filter(stat => States.pinnedSysUsage.indexOf(stat.id) !== -1)

    function sample() {
        parser.line = 0;
        proc.running = false;
        proc.running = true;
    }

    readonly property bool cpuDetail: States.sysUsageDetail.indexOf("cpu") !== -1
    readonly property bool memDetail: States.sysUsageDetail.indexOf("mem") !== -1
    readonly property bool gpuDetail: States.sysUsageDetail.indexOf("gpu") !== -1

    readonly property string cpuText: cpuDetail ? formatTemp(cpuTemp) : cpuUsage + "%"
    readonly property string memText: memDetail ? formatMemDetail() : memUsage + "%"
    readonly property string gpuText: gpuDetail ? formatTemp(gpuTemp) : gpuUsage + "%"

    function formatMemDetail() {
        const used = Math.round(root.memUsedKiB / 1024 / 1024);
        const total = Math.round(root.memTotalKiB / 1024 / 1024);
        return used + "/" + total + "GB";
    }

    function formatTemp(temp) {
        return temp > 0 ? temp + "°C" : "--°C";
    }

    function displayText(id) {
        if (id === "cpu")
            return root.cpuText;
        if (id === "mem")
            return root.memText;
        if (id === "gpu")
            return root.gpuText;
        return "";
    }

    function tipText(id) {
        if (id === "cpu")
            return "CPU";
        if (id === "mem")
            return "Memory";
        if (id === "gpu")
            return "GPU";
        return "";
    }

    function accentColor(colorKey) {
        switch (colorKey) {
        case "secondary":
            return Colors.md3.secondary;
        case "tertiary":
            return Colors.md3.tertiary;
        default:
            return Colors.md3.primary;
        }
    }

    Process {
        id: proc

        command: [
            "sh", "-c",
            "head -1 /proc/stat; " +
            "cat /sys/class/drm/card1/device/gpu_busy_percent 2>/dev/null || echo 0; " +
            "free | awk '/^Mem:/ {print $2,$3}'; " +
            "cpu_temp=0; " +
            "for d in /sys/class/hwmon/hwmon*; do " +
            "  n=$(cat \"$d/name\" 2>/dev/null) || continue; " +
            "  case \"$n\" in k10temp|coretemp|zenpower) " +
            "    cpu_temp=$(cat \"$d/temp1_input\" 2>/dev/null) && break ;; " +
            "  esac; " +
            "done; " +
            "if [ \"${cpu_temp:-0}\" -eq 0 ] 2>/dev/null; then " +
            "  for d in /sys/class/hwmon/hwmon*; do " +
            "    n=$(cat \"$d/name\" 2>/dev/null) || continue; " +
            "    [ \"$n\" = thinkpad ] || continue; " +
            "    for l in \"$d\"/temp*_label; do " +
            "      [ -f \"$l\" ] || continue; " +
            "      [ \"$(cat \"$l\")\" = CPU ] || continue; " +
            "      cpu_temp=$(cat \"${l%_label}_input\" 2>/dev/null); " +
            "      break 2; " +
            "    done; " +
            "  done; " +
            "fi; " +
            "echo \"${cpu_temp:-0}\"; " +
            "gpu_temp=0; " +
            "for d in /sys/class/hwmon/hwmon*; do " +
            "  n=$(cat \"$d/name\" 2>/dev/null) || continue; " +
            "  case \"$n\" in amdgpu|nouveau) " +
            "    gpu_temp=$(cat \"$d/temp1_input\" 2>/dev/null) && break ;; " +
            "  esac; " +
            "done; " +
            "if [ \"${gpu_temp:-0}\" -eq 0 ] 2>/dev/null; then " +
            "  gpu_temp=$(cat /sys/class/drm/card1/device/hwmon/hwmon*/temp1_input 2>/dev/null | head -1); " +
            "fi; " +
            "echo \"${gpu_temp:-0}\""
        ]

        stdout: SplitParser {
            id: parser
            property int line: 0

            onRead: data => {
                if (!data)
                    return;

                const text = data.trim();
                if (!text)
                    return;

                if (parser.line === 0) {
                    const p = text.split(/\s+/);
                    const idle = parseInt(p[4]) + parseInt(p[5]);
                    const total = p.slice(1, 8).reduce((a, b) => a + parseInt(b), 0);
                    if (root.lastCpuTotal > 0 && total !== root.lastCpuTotal)
                        root.cpuUsage = Math.round(100 * (1 - (idle - root.lastCpuIdle) / (total - root.lastCpuTotal)));
                    root.lastCpuTotal = total;
                    root.lastCpuIdle = idle;
                    parser.line = 1;
                } else if (parser.line === 1) {
                    const n = parseInt(text);
                    root.gpuUsage = isNaN(n) ? 0 : n;
                    parser.line = 2;
                } else if (parser.line === 2) {
                    const parts = text.split(/\s+/);
                    const total = parseInt(parts[0]) || 1;
                    const used = parseInt(parts[1]) || 0;
                    root.memTotalKiB = total;
                    root.memUsedKiB = used;
                    root.memUsage = Math.round(100 * used / total);
                    parser.line = 3;
                } else if (parser.line === 3) {
                    const n = parseInt(text);
                    root.cpuTemp = isNaN(n) || n <= 0 ? 0 : Math.round(n / 1000);
                    parser.line = 4;
                } else {
                    const n = parseInt(text);
                    root.gpuTemp = isNaN(n) || n <= 0 ? 0 : Math.round(n / 1000);
                    parser.line = 0;
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
