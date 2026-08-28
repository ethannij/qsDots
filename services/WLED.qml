pragma Singleton

import Quickshell
import QtQuick
import Quickshell.Io

Singleton {
    id: root

    property bool on: true

    Process {
        id: getState
        running: true
        command: ["curl", "-s", "http://10.42.0.233/json/state"]
        stdout: StdioCollector {
            onStreamFinished: {
                const data = JSON.parse(text);
                const power = data.on ?? data.state?.on;
                if (typeof power === "boolean")
                    root.on = power;
            }
        }
    }

    function refresh() {
        getState.running = false;
        getState.running = true;
    }

    function toggle() {
        getState.command = ["curl", "-s", "-X", "POST", "http://10.42.0.233/json/state", "-H", "Content-Type: application/json", "-d", '{"on":"t","v":true}'];
        getState.running = false;
        getState.running = true;
    }
}
