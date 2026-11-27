pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

// Raw cava levels for the media chip. Piped as ascii so the pill can draw
// real spectrum bars instead of a canned bounce.
Singleton {
    id: root

    property int bars: 11
    property int fps: 30
    // Keep cava alive while the chip wants a live spectrum.
    property bool wanted: false
    // 0..1 per band. Settles to zeros when paused / silent / cava gone.
    property var levels: []

    function flat(v) {
        const a = [];
        for (let i = 0; i < root.bars; i++)
            a.push(v);
        return a;
    }

    function settle() {
        root.levels = root.flat(0);
    }

    Component.onCompleted: settle()

    onWantedChanged: {
        if (!wanted)
            settle();
    }

    onBarsChanged: {
        settle();
        if (wanted) {
            proc.running = false;
            restart.restart();
        }
    }

    Process {
        id: proc
        running: root.wanted
        // Write a tiny private config so we don't fight ~/.config/cava/config,
        // then exec cava. Exit quietly if cava isn't installed.
        command: ["sh", "-c",
            "command -v cava >/dev/null 2>&1 || exit 0; " +
            "cfg=\"${XDG_RUNTIME_DIR:-/tmp}/qsDots-cava-media.conf\"; " +
            "printf '%s\\n' " +
            "'[general]' " +
            "'framerate = " + root.fps + "' " +
            "'bars = " + root.bars + "' " +
            "'autosens = 1' " +
            "'' " +
            "'[input]' " +
            "'method = pipewire' " +
            "'source = auto' " +
            "'' " +
            "'[output]' " +
            "'method = raw' " +
            "'channels = mono' " +
            "'mono_option = average' " +
            "'raw_target = /dev/stdout' " +
            "'data_format = ascii' " +
            "'ascii_max_range = 100' " +
            "'bar_delimiter = 59' " +
            "'frame_delimiter = 10' " +
            "'' " +
            "'[smoothing]' " +
            "'monstercat = 1' " +
            "'noise_reduction = 55' " +
            "> \"$cfg\"; " +
            "exec cava -p \"$cfg\""
        ]

        stdout: SplitParser {
            splitMarker: "\n"
            onRead: line => {
                const t = (line || "").trim();
                if (!t)
                    return;
                const parts = t.split(";");
                if (parts.length < root.bars)
                    return;
                const out = [];
                for (let i = 0; i < root.bars; i++) {
                    const n = parseInt(parts[i], 10);
                    out.push(isNaN(n) ? 0 : Math.max(0, Math.min(1, n / 100)));
                }
                root.levels = out;
            }
        }

        onExited: {
            if (root.wanted)
                restart.restart();
        }
    }

    Timer {
        id: restart
        interval: 1500
        onTriggered: {
            if (root.wanted && !proc.running)
                proc.running = true;
        }
    }
}
