import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.theme
import qs.config
import QtQuick.Controls
import Quickshell.Io
import Quickshell.Wayland

PanelWindow {
    id: root
    WlrLayershell.namespace: "notification panel"
    anchors {
        top: true
        right: true
        bottom: true
    }

    margins.top: 16
    margins.right: 16
    margins.bottom: 16

    implicitWidth: 410
    exclusiveZone: 0
    color: "transparent"
    visible: false

    Rectangle {
        id: window
        anchors.fill: parent
        color: Colors.md3.surface

        radius: 20
        opacity: .6
        border.width: 2
        border.color: Colors.md3.shadow
    }

    ColumnLayout {
        id: column
        property int margin: 30
        anchors.topMargin: margin
        anchors.leftMargin: margin
        anchors.rightMargin: margin
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        Rectangle {
            id: widgetPanel
            implicitWidth: widgets.width
            RowLayout {
                id: widgets
                Rectangle {
                    color: Colors.md3.surface
                    width: root.width - column.margin * 2
                    height: 50
                    radius: 12
                    border.width: 1
                    border.color: Colors.md3.tertiary

                    Row {
                        anchors {
                            horizontalCenter: parent.horizontalCenter
                            verticalCenter: parent.verticalCenter
                        }

                        height: parent.height - 6
                        spacing: Config.widgetSpacing


                        WidgetButton {
                            id: volumeButton
                            buttonText: ""
                            property bool menuOpen: volumeMenu.running
                            onClicked: {
                                if (volumeMenu.running) {
                                volumeMenu.running = !volumeMenu.running
                                } else {
                                volumeMenu.exec(volumeMenu.command)
                                }
                            }
                            Process {
                                id: volumeMenu
                                running: false
                                command: ["pavucontrol"]
                            }
                        }

                        WidgetButton {
                            id: bluetoothButton
                            buttonText: "󰂯"
                            property bool menuOpen: bluetoothMenu.running
                            onClicked: {
                                if (bluetoothMenu.running) {
                                    bluetoothMenu.running = !bluetoothMenu.running
                                } else {
                                    bluetoothMenu.exec(bluetoothMenu.command)
                                }

                            }
                            Process {
                                id: bluetoothMenu
                                running: false
                                command: ["blueman-manager"]
                            }
                        }

                        WidgetButton {
                            id: lightButton
                            buttonText: ""
                            onClicked: {
                                lightToggle.exec(lightToggle.command)
                            }
                            Process {
                                id: lightToggle
                                running: false
                                command: ["curl", "10.42.0.233/win&T=2"]
                            }
                        }
                    }
                }
            }
        }
    }
    component WidgetButton: Item {
        id: widgetButton
        property alias buttonText: text.text
        property alias buttonColor: button.color
        property alias textColor: text.color
        property alias buttonHeight: button.height
        property alias buttonWidth: button.width
        property alias isHover: mouse.containsMouse
        implicitWidth: button.width
        implicitHeight: button.height
        signal clicked

        Rectangle {
            id: button
            color: mouse.containsMouse? Colors.md3.primary_container : Colors.md3.surface
            implicitWidth: 45
            implicitHeight: 45
            radius: 12

            Text {
                id: text

                anchors.centerIn: parent
                color: Colors.md3.on_surface
                font {
                    family: Config.fontFamilyPropo
                    pointSize: Config.fontSizeIcon
                }
            }
        }

        MouseArea {
            id: mouse
            anchors.fill: button
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton
            onClicked: widgetButton.clicked()
            cursorShape: Qt.PointingHandCursor
        }
    }

    /*component Lights: Item {
        id: lightItem
        implicitWidth: lightbutton.implicitWidth
        implicitHeight: lightbutton.implicitHeight
        property bool isClicked: false

        Process {
            id: shellCommand
        }

        WidgetButton {
            id: lightbutton
            buttonText: ""
            buttonColor: lightItem.isClicked ? "green" : "red"
            onClicked: {
                if (lightItem.isClicked) {
                        
                    shellCommand.exec("sh", "-c", "notify-send", "'Hello World'");
                }
            }
        }
    }*/
}
