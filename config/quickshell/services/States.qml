pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    readonly property string path: Quickshell.env("HOME") + "/.local/state/quickshell/states.json"

    property alias oled: adapter.oled
    property alias gamemode: adapter.gamemode
    property alias wallpaperCycleSeconds: adapter.wallpaperCycleSeconds

    FileView {
        path: root.path
        watchChanges: true
        onFileChanged: reload()
        onAdapterUpdated: if (loaded)
            writeAdapter()

        JsonAdapter {
            id: adapter
            property bool oled: false
            property bool gamemode: false
            property int wallpaperCycleSeconds: 0
        }
    }
}