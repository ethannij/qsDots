import QtQuick
import qs.theme
import qs.config

Item {
    id: root

    property color color: Colors.md3.surface
    property bool hasBorder: true
    property color borderColor: hasBorder ? Colors.md3.shadow : "transparent"
    property int borderWidth: hasBorder ? Config.borderWidth : 0
    property real radius: Config.radiusPill
    property int padH: Config.pillPadH
    property int padV: Config.pillPadV

    default property alias content: content.data

    implicitWidth: content.implicitWidth + padH * 2
    implicitHeight: content.implicitHeight + padV * 2

    Rectangle {
        anchors.fill: parent
        color: root.color
        border.width: root.borderWidth
        border.color: root.borderColor
        radius: root.radius
    }

    Row {
        id: content
        anchors.centerIn: parent
        spacing: Config.widgetSpacing
    }

    signal clicked(var mouse)
    signal wheel(var wheel)
    signal hover(var hover)
    property bool interactive: false
    property alias cursorShape: mouse.cursorShape
    property alias containsMouse: mouse.containsMouse

    property bool hovered: false

    MouseArea {
        id: mouse
        anchors.fill: parent
        enabled: root.interactive
        visible: root.interactive
        hoverEnabled: root.interactive
        onClicked: (mouse) => root.clicked(mouse)
        onWheel: (wheel) => root.wheel(wheel)
    }
}