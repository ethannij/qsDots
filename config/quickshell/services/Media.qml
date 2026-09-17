pragma Singleton
import Quickshell.Services.Mpris
import Quickshell
import QtQuick

Singleton {
    id: root

    property var stickyPlayer: null

    readonly property var player: {
        const list = Mpris.players.values
        const playing = list.find(p => p.isPlaying)
        if (playing)
            return playing
        if (root.stickyPlayer && list.indexOf(root.stickyPlayer) !== -1)
            return root.stickyPlayer
        return list[0] ?? null
    }

    onPlayerChanged: {
        if (root.player)
            root.stickyPlayer = root.player
    }

    readonly property bool active: player !== null
    readonly property bool isPlaying: player?.isPlaying ?? false
    readonly property string name: player?.identity ?? ""
    readonly property string title: player?.trackTitle ?? ""
    readonly property string artist: player?.trackArtist ?? ""
    readonly property string artURL: player?.trackArtUrl ?? ""
    readonly property real length: player?.lengthSupported ? player.length : 0
    readonly property real position: player?.position ?? 0
    readonly property real progress: length > 0 ? Math.max(0, Math.min(1, position / length)) : 0
    readonly property var playbackState: player?.playbackState
    readonly property bool canToggle: player?.canTogglePlaying ?? false
    readonly property bool canGoNext: player?.canGoNext ?? false
    readonly property bool canGoPrevious: player?.canGoPrevious ?? false
    readonly property bool canSeek: (player?.canSeek && player?.positionSupported && length > 0) ?? false

    function toggle() {
        if (root.canToggle)
            root.player.togglePlaying()
    }

    function next() {
        if (root.canGoNext)
            root.player.next()
    }

    function previous() {
        if (root.canGoPrevious)
            root.player.previous()
    }

    function seekTo(fraction) {
        if (!root.canSeek)
            return
        root.player.position = Math.max(0, Math.min(1, fraction)) * root.length
    }

    FrameAnimation {
        running: root.isPlaying
        onTriggered: {
            if (root.player)
                root.player.positionChanged()
        }
    }
}
