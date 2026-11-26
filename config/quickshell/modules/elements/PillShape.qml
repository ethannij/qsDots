import QtQuick
import qs.theme
import qs.config

Item {
    id: root

    property bool chrome: true
    property color color: Colors.md3.surface
    property bool hasBorder: true
    property color borderColor: hasBorder ? Colors.md3.shadow : "transparent"
    property int borderWidth: hasBorder ? Config.borderWidth : 0
    property real radius: Config.radiusPill
    property int padH: Config.pillPadH
    property int padV: Config.pillPadV
    property bool interactive: true
    property var cursorShape: Qt.PointingHandCursor

    default property alias content: content.data
    readonly property alias hovered: hover.hovered
    signal tapped
    signal tappedAlternate

    implicitWidth: content.implicitWidth + padH * 2
    implicitHeight: content.implicitHeight + padV * 2

    HoverHandler {
        id: hover
        enabled: root.interactive
        cursorShape: root.cursorShape
    }

    TapHandler {
        enabled: root.interactive
        gesturePolicy: TapHandler.ReleaseWithinBounds
        onTapped: root.tapped()
    }

    TapHandler {
        enabled: root.interactive
        acceptedButtons: Qt.RightButton
        gesturePolicy: TapHandler.ReleaseWithinBounds
        onTapped: root.tappedAlternate()
    }

    Rectangle {
        visible: root.chrome
        anchors.fill: parent
        radius: root.radius
        color: root.borderWidth > 0 ? root.borderColor : root.color
        antialiasing: true
        Rectangle {
            anchors.fill: parent
            anchors.margins: root.borderWidth
            radius: Math.max(0, root.radius - root.borderWidth)
            color: root.color
            visible: root.borderWidth > 0
            antialiasing: true
        }
    }

    Row {
        id: content
        anchors.centerIn: parent
        spacing: Config.widgetSpacing
    }
}
