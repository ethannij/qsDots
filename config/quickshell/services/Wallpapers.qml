pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.config
import qs.theme
import qs.services

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
        matugen.command = matugenCommand(originalPath(name));
        matugen.running = false;
        matugen.running = true;
    }

    // Randomly choose wallpaper
    function random(fromCycle) {
        const pool = files.filter(n => n !== currentName);
        const pick = (pool.length ? pool : files);
        if (!pick.length)
            return;
        apply(pick[Math.floor(Math.random() * pick.length)], !!fromCycle);
    }

    // Determine matugen command based on OLED state
    function matugenCommand(imagePath) {
        const cmd = ["matugen", "--source-color-index", "0", "--continue-on-error"];
        if (OLED.active)
            cmd.push("--import-json", Quickshell.env("HOME") + "/.config/matugen/oled.json");
        // cmd.push("--lightness-dark", "-0.1"); // Alternative approach

        cmd.push("image", imagePath);
        return cmd;
    }

    // Reapply colorscheme and wallpaper (for OLED toggle)
    function reapply() {
        apply(currentName, true);
    }

    readonly property int cycleSeconds: States.wallpaperCycleSeconds

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
        States.wallpaperCycleSeconds = seconds;
    }

    function stopCycle() {
        States.wallpaperCycleSeconds = 0;
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

        function applyWallpaper(name: string): void {
            Wallpapers.apply(name);
        }

        function cycle(seconds: int): void {
            if (seconds > 0)
                Wallpapers.startCycle(seconds);
            else
                Wallpapers.stopCycle();
        }
    }
    Component.onCompleted: {
        fetcher.running = false;
        fetcher.running = true;
    }
}
