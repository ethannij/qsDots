import QtQuick
import qs.config
import qs.theme

Item {
    id: root

    Text {
        id: session
        text: "󰐥"
        font {
            family: Config.fontFamilyPropo
            pointSize: Config.fontSize
            weight: Config.fontWeight
        }
        color: Colors.md3.on_surface
    }
}