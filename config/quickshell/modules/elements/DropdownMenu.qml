import QtQuick
import qs.theme
import qs.config

Item {
    id: root

    property string text: ""
    property var model: []
    property string textRole: ""
    property string direction: "right"
    property int labelWidth: 100
    property int itemWidth: 200
    property int radius: 10
    property int menuRadius: 6
    property int borderWidth: 0
    property color borderColor: "transparent"
    property color labelColor: Colors.md3.secondary
    property color itemColor: Colors.md3.on_surface_variant
    property color itemHoverColor: Colors.md3.primary
    property int menuPadding: 0
    property font labelFont: StylizedFont.body
    property font itemFont: StylizedFont.tooltip
    property int labelAlignment: Text.AlignLeft
    property bool opened: false

    signal selected(var modelData)

    function labelFor(value) {
        if (root.textRole !== "" && value !== null && value !== undefined)
            return value[root.textRole] ?? "";
        return value ?? "";
    }

    implicitWidth: button.implicitWidth
    implicitHeight: button.implicitHeight
    z: opened ? 2 : 0

    Rectangle {
        id: button
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        implicitWidth: label.width + Config.spaceSm
        implicitHeight: label.implicitHeight + Config.spaceSm
        color: Colors.md3.surface_variant
        radius: root.radius
        border.width: root.borderWidth
        border.color: root.borderColor
        z: 1

        Text {
            id: label
            anchors.centerIn: parent
            text: root.text
            elide: Text.ElideRight
            clip: true
            width: root.labelWidth
            horizontalAlignment: root.labelAlignment
            color: root.labelColor
            font: root.labelFont
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: root.opened = !root.opened
        }
    }

    Rectangle {
        id: menu
        anchors.left: button.right
        anchors.verticalCenter: button.verticalCenter
        implicitWidth: column.implicitWidth + root.menuPadding * 2
        implicitHeight: column.implicitHeight + root.menuPadding * 2
        color: Colors.md3.surface_variant
        visible: root.opened
        enabled: visible
        radius: root.menuRadius
        anchors.topMargin: Config.spaceSm
        anchors.bottomMargin: Config.spaceSm
        z: 2

        states: [
            State {
                when: root.direction === "left"
                AnchorChanges {
                    target: menu
                    anchors.left: undefined
                    anchors.right: button.left
                    anchors.verticalCenter: button.verticalCenter
                }
            },
            State {
                when: root.direction === "down"
                AnchorChanges {
                    target: menu
                    anchors.left: undefined
                    anchors.verticalCenter: undefined
                    anchors.top: button.bottom
                    anchors.horizontalCenter: button.horizontalCenter
                }
            },
            State {
                when: root.direction === "up"
                AnchorChanges {
                    target: menu
                    anchors.left: undefined
                    anchors.verticalCenter: undefined
                    anchors.bottom: button.top
                    anchors.horizontalCenter: button.horizontalCenter
                }
            }
        ]

        Column {
            id: column
            anchors.fill: parent
            anchors.margins: root.menuPadding
            spacing: Config.spaceSm

            Repeater {
                model: root.model

                Text {
                    id: menuText
                    required property var modelData
                    color: menuMouse.containsMouse ? root.itemHoverColor : root.itemColor
                    text: root.labelFor(modelData)
                    font: root.itemFont
                    elide: Text.ElideRight
                    clip: true
                    width: root.itemWidth

                    MouseArea {
                        id: menuMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        z: 2
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            root.selected(menuText.modelData);
                            root.opened = false;
                        }
                    }
                }
            }
        }
    }
}
