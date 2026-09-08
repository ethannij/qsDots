pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string weatherType: ""
    property string weatherTemperature: ""
    property url weatherIcon: {
        switch (root.weatherType) {
        case "113":
            return Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/weather/clear.svg")); // Sunny / Clear
        case "116":
        case "119":
        case "122":
            return Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/weather/cloudy.svg")); // Partly cloudy → overcast
        case "143":
        case "248":
        case "260":
            return Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/weather/foggy.svg")); // Mist / fog
        case "176":
        case "263":
        case "266":
        case "293":
        case "296":
        case "299":
        case "302":
        case "305":
        case "308":
        case "353":
        case "356":
        case "359":
            return Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/weather/rainy.svg")); // Drizzle / rain / showers
        case "182":
        case "185":
        case "281":
        case "284":
        case "311":
        case "314":
        case "317":
        case "320":
        case "350":
        case "362":
        case "365":
        case "374":
        case "377":
            return Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/weather/sleet.svg")); // Sleet / freezing rain / ice
        case "179":
        case "227":
        case "230":
        case "323":
        case "326":
        case "329":
        case "332":
        case "335":
        case "338":
        case "368":
        case "371":
            return Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/weather/snowy.svg")); // Snow / blizzard
        case "200":
        case "386":
        case "389":
        case "392":
        case "395":
            return Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/weather/thunder.svg")); // Thunder
        default:
            return Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/weather/cloudy.svg")); // Default to cloudy
        }
    }

    signal timerRestarted()

    Process {
        id: weatherFetcher

        command: ["curl", "-s", "https://wttr.in/?format=j1"] // Reports in JSON format, split into weather code (parsed for icon) and temperature

        stdout: StdioCollector {
            onStreamFinished: {
                const data = JSON.parse(text);
                const now = data.current_condition[0];
                root.weatherType = now.weatherCode;
                root.weatherTemperature = now.temp_F + "°F";
            }
        }

    }

    Timer {
        id: timer

        interval: 900000
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: {
            weatherFetcher.running = false;
            weatherFetcher.running = true;
        }
    }

}
