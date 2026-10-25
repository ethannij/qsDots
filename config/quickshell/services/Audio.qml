pragma Singleton
import Quickshell
import QtQuick
import Quickshell.Services.Pipewire
import qs.config

Singleton {
    id: root
    property var sink: Pipewire.defaultAudioSink
    property list<var> sinks: Pipewire.nodes.values.filter(node => node.isSink && node.audio && !node.isStream)

    readonly property bool ready: sink && sink.ready
    readonly property bool muted: ready && sink.audio.muted
    readonly property int vol: ready ? Math.round(sink.audio.volume * 100) : 0

    readonly property string description: ready ? sink.description : ""
    readonly property string nickname: ready ? sink.nickname : ""
    readonly property string name: ready ? sink.name : ""
    readonly property string iconName: ready ? (sink.properties["device.icon-name"] || "") : ""

    readonly property string deviceType: {
        const type = iconName;
        switch (type) {
            case type.includes("headphone"):
                return "headphones";
            case type.includes("headset"):
                return "headset";
            case type.includes("speaker"):
                return "speakers";
            case type.includes("handsfree"):
                return "handsfree";
            default: "speakers"
        }
    }

    function setDefaultSink(node) {
        if (!node)
            return;
        Pipewire.preferredDefaultAudioSink = node;
    }

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

    function setVolume(value) {
        if (!ready)
            return;
        root.sink.audio.volume = Math.min(Math.max(value, Config.volumeMin), Config.volumeMax);
    }

    readonly property url icon: {
        if (!ready)
            return Qt.resolvedUrl(Quickshell.shellPath("modules/img/audio/off.svg"));
        if (muted)
            return Qt.resolvedUrl(Quickshell.shellPath("modules/img/audio/off.svg"));

        if (vol == 0)
            return Qt.resolvedUrl(Quickshell.shellPath("modules/img/audio/mute.svg"));
        if (vol < 50)
            return Qt.resolvedUrl(Quickshell.shellPath("modules/img/audio/low.svg"));
        if (vol >= 50)
            return Qt.resolvedUrl(Quickshell.shellPath("modules/img/audio/high.svg"));

        return Qt.resolvedUrl(Quickshell.shellPath("modules/img/audio/off.svg"));
    }

    PwObjectTracker {
        objects: [root.sink, root.sinks]
    }
}
