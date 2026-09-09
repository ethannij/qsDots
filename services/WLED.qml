import QtQuick
import Quickshell
import Quickshell.Io
pragma Singleton

Singleton {
    id: root

    property bool wledExists: false
    property bool on: true

    function refresh() {
        getState.running = false;
        getState.running = true;
    }

    function toggle() {
        setState.command = ["curl", "-s", "-X", "POST", "http://10.42.0.233/json/state", "-H", "Content-Type: application/json", "-d", '{"on":"t","v":true}'];
        setState.running = false;
        setState.running = true;
    }

    // Convert kelvin (from HyprSunset -> Gain values for hyperHDR)
    function kelvinToGains(kelvin) {
        const k = kelvin / 100;
        let r, g, b;
        if (k <= 66) {
            r = 255;
            g = 99.4708 * Math.log(k) - 161.12;
        } else {
            r = 329.699 * Math.pow(k - 60, -0.133205);
            g = 288.122 * Math.pow(k - 60, -0.0755148);
        }
        if (k >= 66)
            b = 255;
        else if (k <= 19)
            b = 0;
        else
            b = 138.518 * Math.log(k - 10) - 305.045;
        const c = (n) => {
            return Math.max(0, Math.min(255, n)) / 255;
        };
        return [c(r), c(g), c(b)];
    }

    function setTemperature(kelvin) {
        const rgb = kelvinToGains(kelvin);
        const n = (v) => {
            return v.toFixed(4);
        };
        const payload = '{"command":"adjustment","adjustment":{' + '"classic_config":true,' + '"temperatureSetting":"custom",' + '"temperatureRed":' + n(rgb[0]) + ',' + '"temperatureGreen":' + n(rgb[1]) + ',' + '"temperatureBlue":' + n(rgb[2]) + '}}';
        setState.command = ["curl", "-sS", "--connect-timeout", "1", "--max-time", "2", "-X", "POST", "http://127.0.0.1:8090/json-rpc", "-H", "Content-Type: application/json", "-d", payload];
        setState.running = false;
        setState.running = true;
    }

    Process {
        id: getState

        running: true
        command: ["curl", "-sS", "-f", "--connect-timeout", "1", "--max-time", "2", "http://10.42.0.233/json/si"]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const data = JSON.parse(text);
                    const info = data.info ?? data;
                    const state = data.state ?? data;
                    root.wledExists = info.brand === "WLED" || !!info.ver;
                    if (typeof state.on === "boolean")
                        root.on = state.on;

                } catch (e) {
                    root.wledExists = false;
                }
            }
        }

    }

    Process {
        id: setState

        command: ["curl", "-sS", "-f", "--connect-timeout", "1", "--max-time", "2", "-X", "POST", "http://10.42.0.233/json/state", "-H", "Content-Type: application/json", "-d", '{"on":"t","v":true}']

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const state = JSON.parse(text);
                    if (typeof state.on === "boolean")
                        root.on = state.on;

                } catch (e) {
                }
            }
        }

    }

    Timer {
        id: refreshTimer

        interval: 300000
        onTriggered: {
            getState.running = false;
            getState.running = true;
        }
    }

}
