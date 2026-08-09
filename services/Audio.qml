pragma Singleton
import Quickshell
import QtQuick
import Quickshell.Services.Pipewire
import qs.config

Singleton {
    id: root
    property var sink: Pipewire.defaultAudioSink

    readonly property bool ready: sink && sink.ready
    readonly property bool muted: ready && sink.audio.muted
    readonly property int vol: ready ? Math.round(sink.audio.volume * 100) : 0

    readonly property string description: ready ? sink.description : ""

    function toggleMute() {
        if (!ready)
            return;
        root.sink.audio.muted = !root.sink.audio.muted;
    }

    function volumeUp() {
        if (!ready)
            return;
        root.sink.audio.volume = Math.min(sink.audio.volume + Config.volumeStep, Config.volumeMax);
    }

    function volumeDown() {
        if (!ready)
            return;
        root.sink.audio.volume = Math.max(sink.audio.volume - Config.volumeStep, Config.volumeMin);
    }

    readonly property string icon: {
        if (!ready)
            return String.fromCodePoint(0xF0581);
        if (muted)
            return String.fromCodePoint(0xF075F);

        if (vol == 0)
            return String.fromCodePoint(0xF0581);
        if (vol < 34)
            return String.fromCodePoint(0xF057F);
        if (vol < 67)
            return String.fromCodePoint(0xF0580);

        return String.fromCodePoint(0xF057E);
    }

    PwObjectTracker {
        objects: [root.sink]
    }
}
