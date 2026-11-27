pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    readonly property string path: Quickshell.env("HOME") + "/.local/state/quickshell/states.json"
    readonly property string defaultsPath: Quickshell.env("HOME") + "/.local/state/quickshell/defaults.json"

    property bool ready: false
    // Block adapter writes until the file has been read once. Otherwise a
    // reload/init can flush JsonAdapter defaults over the user's real prefs.
    property bool allowWrites: false

    property alias twentyFourHourClock: adapter.twentyFourHourClock
    property alias workspaceCount: adapter.workspaceCount
    property alias wallpaperCycleSeconds: adapter.wallpaperCycleSeconds
    property alias wallpaperDirectory: adapter.wallpaperDirectory

    property alias colorScheme: adapter.colorScheme
    property alias gamemode: adapter.gamemode
    property alias doNotDisturb: adapter.doNotDisturb
    property alias inhibitIdle: adapter.inhibitIdle
    property alias temperatureState: adapter.temperatureState
    property alias gamma: adapter.gamma
    property alias notificationListHeldClosed: adapter.notificationListHeldClosed
    property alias pinnedBatteries: adapter.pinnedBatteries
    property alias pinBatteryOnAlert: adapter.pinBatteryOnAlert
    property alias batteryLowPercent: adapter.batteryLowPercent
    property alias showVolumeFace: adapter.showVolumeFace
    property alias showWorkspaceFace: adapter.showWorkspaceFace
    property alias showDoNotDisturb: adapter.showDoNotDisturb
    property alias liveMediaVisualizer: adapter.liveMediaVisualizer

    function togglePinned(id) {
        const current = pinnedBatteries;
        pinnedBatteries = current.indexOf(id) === -1 ? current.concat([id]) : current.filter(x => x !== id);
    }

    function markReady() {
        if (ready || !file.loaded)
            return;
        ready = true;
        // Defer writes one tick so the loaded JSON is fully applied first.
        Qt.callLater(() => {
            root.allowWrites = true;
        });
    }

    // Copy defaults.json -> states.json (or write {} if defaults missing), then reload.
    function seedFromDefaults() {
        seed.running = false;
        seed.running = true;
    }

    Process {
        id: seed
        running: false
        command: ["sh", "-c",
            "defaults=\"" + root.defaultsPath + "\"; " +
            "states=\"" + root.path + "\"; " +
            "mkdir -p \"$(dirname \"$states\")\"; " +
            "if [ -f \"$defaults\" ]; then cp -f \"$defaults\" \"$states\"; " +
            "else printf '{}\\n' > \"$states\"; fi"
        ]
        onExited: file.reload()
    }

    FileView {
        id: file
        path: root.path
        watchChanges: true
        onFileChanged: {
            // External edits only. Don't persist defaults mid-reload.
            root.allowWrites = false;
            reload();
        }
        onLoadedChanged: {
            if (!loaded)
                return;
            if (!root.ready)
                root.markReady();
            else
                Qt.callLater(() => {
                    root.allowWrites = true;
                });
        }
        onAdapterUpdated: {
            if (loaded && root.allowWrites)
                writeAdapter();
        }
        onLoadFailed: root.seedFromDefaults()
        Component.onCompleted: root.markReady()

        // Keep these in sync with local/state/quickshell/defaults.json.
        // Used only as an in-memory fallback before seed/load finishes.
        JsonAdapter {
            id: adapter
            property bool twentyFourHourClock: false
            property int workspaceCount: 5
            property int wallpaperCycleSeconds: 0
            property string wallpaperDirectory: "/home/ethannij/Pictures/wallpapers"
            property string colorScheme: "dark"
            property bool gamemode: false
            property bool doNotDisturb: false
            property bool inhibitIdle: false
            property string temperatureState: "auto"
            property int gamma: 100
            property bool notificationListHeldClosed: false
            property list<string> pinnedBatteries: []
            property bool pinBatteryOnAlert: true
            property int batteryLowPercent: 25
            property bool showVolumeFace: true
            property bool showWorkspaceFace: true
            property bool showDoNotDisturb: true
            property bool liveMediaVisualizer: true
        }
    }
}
