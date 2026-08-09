import QtQuick
import qs.theme
import qs.config
import Quickshell

Item {
    id: root
    property color color: Colors.md3.surface
    property color borderColor: Colors.md3.outline
    property int borderWidth: Config.borderWidth
    property int radius: Config.radiusBox
    property int padH: Config.hoverTipPadH
    property int padV: Config.hoverTipPadV
    property string text: ""
    property var anchorItem: null



    PopupWindow {
        id: tip
        implicitWidth: tooltipText.implicitWidth + 16
        implicitHeight: tooltipText.implicitHeight + 16
        anchor {
            item: anchorItem
            edges: Edges.Bottom | Edges.Left
            gravity: Edges.Bottom | Edges.Right
        }
        color: root.color
        visible: anchorItem.containsMouse

    
    Rectangle {
        anchors.fill: parent
        color: root.color
        border.width: root.borderWidth
        border.color: root.borderColor
        radius: root.radius
    }

    Text {
        anchors.centerIn: parent
        visible: anchorItem.containsMouse
        id: tooltipText
        color: Colors.md3.on_surface
        text: root.text
        font {
            family: Config.fontFamilyPropo
            pointSize: Config.fontSizeTip
        }
    }
}
}