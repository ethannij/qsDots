import QtQuick
import Quickshell
import Quickshell.Io
import qs.config
import qs.modules.elements
import qs.theme

Item {
    id: root


    property var widgets: [{
        "icon": "",
        "title": "Wifi"
    }, {
        "icon": "󰂯",
        "title": "Bluetooth"
    }, {
        "icon": "󰌵",
        "title": "WLED",
        "cmd": ["curl", "10.42.0.233/win&T=2"]
    }]

    Flow {
        anchors.fill: parent
        spacing: Config.spaceSm

        Repeater {
            model: root.widgets

            PillShape {
                id: widget

                required property var modelData

                width: 60
                interactive: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    Quickshell.execDetached(modelData.cmd);
                }
                color: mouse.containsMouse ? Colors.md3.surface_variant : Colors.md3.surface

                Text {
                    text: widget.modelData.icon
                    font: StylizedFont.icon
                    color: Colors.md3.on_surface
                }

            }

        }

    }

}
