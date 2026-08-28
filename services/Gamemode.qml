pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs.config

Singleton {
    id: root

    property bool active: false
    property int snapshotIndex: 0
    property var saved: ({})

    readonly property list<string> keys: ["animations:enabled", "decoration:rounding", "decoration:blur:enabled", "general:border_size", "general:gaps_in", "general:gaps_out"]

    onActiveChanged: {
        active ? beginSnapshot() : restore();
    }

    function toggle() {
        active = !active;
    }

    function beginSnapshot() {
        snapshotIndex = 0;
        saved = {};
        runSnapshot();
    }

    function runSnapshot() {
        snapshotProc.command = ["hyprctl", "getoption", "-j", keys[snapshotIndex]];
        snapshotProc.running = false;
        Qt.callLater(() => {
            snapshotProc.running = true;
        });
    }

    function parseOption(text) {
        if (text.trim() === "no such option")
            return undefined;

        const obj = JSON.parse(text);
        for (const key in obj) {
            if (key === "option" || key === "set")
                continue;
            return obj[key];
        }
        return undefined;
    }

    function restore() {
        snapshotProc.running = false;
        const parts = [];
        for (const key of keys) {
            if (saved[key] === undefined)
                continue;
            parts.push(`keyword ${key} ${keywordValue(saved[key])}`);
        }
        if (parts.length)
            Quickshell.execDetached(["hyprctl", "--batch", parts.join(" ; ")]);
    }

    function applyKeywords() {
        const batch = keys.map(key => `keyword ${key} ${gameValue(key)}`).join(" ; ");
        Quickshell.execDetached(["hyprctl", "--batch", batch]);
    }

    function keywordValue(value) {
        if (value === undefined || value === null)
            return "";
        if (Array.isArray(value))
            return value.join(" ");
        if (typeof value === "boolean")
            return value ? "1" : "0";
        return String(value);
    }

    function gameValue(key) {
        switch (key) {
        case "animations:enabled":
        case "decoration:blur:enabled":
            return "0";
        case "decoration:rounding":
        case "general:border_size":
            return "0";
        case "general:gaps_in":
        case "general:gaps_out":
            return "0 0 0 0";
        default:
            return "0";
        }
    }

    Process {
        id: snapshotProc

        stdout: StdioCollector {
            onStreamFinished: {
                if (!root.active)
                    return;

                const key = root.keys[root.snapshotIndex];
                try {
                    const value = root.parseOption(text);
                    if (value !== undefined) {
                        const next = Object.assign({}, root.saved);
                        next[key] = value;
                        root.saved = next;
                    }
                } catch (e) {
                    console.log(`[Gamemode] failed to fetch "${key}: ${text.trim()} (${e})`);
                }

                root.snapshotIndex++;
                if (root.snapshotIndex < root.keys.length)
                    root.runSnapshot();
                else
                    root.applyKeywords();

                console.log(`[Gamemode] success`)
            }
        }
    }
}
