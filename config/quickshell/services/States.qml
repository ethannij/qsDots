pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    readonly property string path: Quickshell.env("HOME") + "/.local/state/quickshell/states.json"

    property bool ready: false

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

    function markReady() {
        if (ready || !file.loaded)
            return;
        ready = true;
    }

    FileView {
        id: file
        path: root.path
        watchChanges: true
        onFileChanged: reload()
        onLoadedChanged: root.markReady()
        onAdapterUpdated: if (loaded)
            writeAdapter()
        Component.onCompleted: root.markReady()

        JsonAdapter {
            id: adapter
            property bool twentyFourHourClock: false
            property int workspaceCount: 5
            property int wallpaperCycleSeconds: 0
            property string wallpaperDirectory: "/home/ethannij/Pictures/wallpapers"
            property string colorScheme: "light"
            property bool gamemode: false
            property bool doNotDisturb: false
            property bool inhibitIdle: false
            property string temperatureState: "auto"
            property int gamma: 100
            property bool notificationListHeldClosed: false
        }
    }
}
