import Quickshell
import Quickshell.Io
import QtQuick
import qs.modules.elements
import qs.theme
import qs.config


PillShape {
    id: notifButton
    Text {
        text: String.fromCodePoint(0xF0A2)
        color: Colors.md3.on_primary_container
        font {
            family: Config.fontFamilyPropo
            pointSize: Config.fontSize
            weight: Config.fontWeightBold
        }
    }
    interactive: true
    cursorShape: Qt.PointingHandCursor
    onClicked: {
        openNotif.running = true
    }
    Process {
        id: openNotif
        command: ["sh", "-c", "swaync-client -t -sw"]
        running: false
    }

    Process {
        id: startNotif
        command: ["sh", "-c", "swaync-client -swb"]
        running: true
    }
    
}
