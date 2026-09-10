pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.config
import qs.theme

Singleton {
    id: root

    property list<string> files: [] // array of files
    readonly property int thumbW: 320 // thumbnail width
    readonly property int thumbH: 180 // thumbnail height
    readonly property string cacheDir: Quickshell.env("HOME") + "/.cache/Pictures/wallpapers" // Path to cache/thumbnails

    readonly property url icon: Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/ui/wallpaper.svg"))
    readonly property url cycleIcon: Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/ui/cycle.svg"))

    readonly property string wallDir: Config.wallpaperDirectory // path to fullsize image

    // Read currently set wallpaper
    readonly property string currentName: {
        const p = Colors.wallpaper;
        const i = p.lastIndexOf("/");
        return i >= 0 ? p.slice(i + 1) : p;
    }

    // Return path for fullsize image
    function originalPath(name) {
        return wallDir + "/" + name;
    }
    // return URL for each found file
    function urlFor(name) {
        return "file://" + cacheDir + "/" + name;
    }

    // Apply wallpaper (also stops random wallpaper cycle if it's running)
    function apply(name, fromCycle) {
        if (!name)
            return;
        if (!fromCycle)
            stopCycle();
        matugen.command = ["matugen", "--source-color-index", "0", "--continue-on-error", "image", originalPath(name)];
        matugen.running = false;
        matugen.running = true;
    }

    function random(fromCycle) {
        const pool = files.filter(n => n !== currentName);
        const pick = (pool.length ? pool : files);
        if (!pick.length)
            return;
        apply(pick[Math.floor(Math.random() * pick.length)], !!fromCycle);
    }

    FileView {
        id: cycleFile
        path: Quickshell.env("HOME") + "/.local/state/quickshell/wallpaper-cycle.json"
        watchChanges: true
        onFileChanged: reload()
        onAdapterUpdated: writeAdapter()

        JsonAdapter {
            id: cycleAdapter
            property int seconds: 0
        }
    }

    property alias cycleSeconds: cycleAdapter.seconds

    // This process does a few really important things:
    // 1. Creates a cache directory for wallpaper thumbnails
    // 2. Queries wallpaper directory for all images and creates thumbnails for them (this way we don't have to load full images into memory)
    // 3. Updates the files array with wallpapers to choose from
    Process {
        id: fetcher
        running: true
        command: ["bash", "-c", "mkdir -p \"$HOME/.cache/Pictures/wallpapers\"; " + "for f in \"" + Config.wallpaperDirectory + "\"/*.{jpg,jpeg,png,webp}; do " + "  [ -f \"$f\" ] || continue; " + "  n=$(basename \"$f\"); " + "  t=\"$HOME/.cache/Pictures/wallpapers/$n\"; " + "  [ -f \"$t\" ] || convert -strip \"$f\" -thumbnail 500x500^ -gravity center -extent 500x500 \"$t\"; " + "  echo \"$n\"; " + "done"]
        stdout: StdioCollector {
            onStreamFinished: {
                root.files = text.trim().split("\n").filter(s => s.length > 0);
            }
        }
    }

    Process {
        id: matugen
        running: false
    }

    readonly property bool cycling: cycleSeconds > 0

    function startCycle(seconds) {
        cycleSeconds = seconds;
    }

    function stopCycle() {
        cycleSeconds = 0;
    }

    Timer {
        interval: Math.max(1, root.cycleSeconds) * 1000
        repeat: true
        running: root.cycling
        onTriggered: root.random(true)
    }

    IpcHandler {
        id: ipc
        target: "wallpapers"

        function random(): void {
            Wallpapers.random();
        }

        function apply(name: string): void {
            Wallpapers.apply(name);
        }

        function cycle(seconds: int): void {
            if (seconds > 0)
                Wallpapers.startCycle(seconds);
            else
                Wallpapers.stopCycle();
        }
    }
}
