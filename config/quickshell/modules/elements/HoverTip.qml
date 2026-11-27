import QtQuick
import qs.config
import qs.theme
import qs.modules.elements

Item {
    id: root

    required property string hoverText
    property bool shown: false

    width: tip.implicitWidth
    height: tip.implicitHeight
    opacity: shown ? 1 : 0
    visible: opacity > 0 && hoverText !== ""

    Behavior on opacity {
        enabled: Config.animMs > 0
        NumberAnimation {
            duration: Config.animMs
            easing.type: Easing[Config.animEasing]
        }
    }

    PillShape {
        id: tip
        interactive: false
        anchors.fill: parent
        color: Colors.role.raised
        borderColor: Colors.role.raised
        radius: Config.radiusBox
        padH: Config.hoverTipPadH
        padV: Config.hoverTipPadV

        Text {
            text: root.hoverText
            font: StylizedFont.tooltip
            color: Colors.md3.on_surface
        }
    }
}
