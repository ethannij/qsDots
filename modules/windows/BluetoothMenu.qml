import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import qs.modules.elements
import qs.services
import qs.theme
import qs.config

Window {
    id: root
    title: "Bluetooth Manager"
    width: 420
    height: 520
    visible: false
    color: Colors.md3.surface

    // Stop discovering when window is not visible, I dont know if this saves resources but it bothered me
    onVisibleChanged: {
        if (!visible)
            Bluetooth.defaultAdapter.discovering = false;
    }

    // Discover would stay on indefinitely without a timer
    Timer {
        id: discoverTimer
        interval: 30000
        onTriggered: {
            if (Bluetooth.defaultAdapter)
                Bluetooth.defaultAdapter.discovering = false;
        }

        repeat: false
    }

    // Mostly just UI, theres an IPC handler if you keep scrolling. I also don't know what would happen if the device list was longer than the window, I think it just scrolls.
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Config.spaceMd
        spacing: Config.spaceMd

        Item {
            id: header
            implicitWidth: parent.width
            implicitHeight: Math.max(title.implicitHeight + divider.implicitHeight, stateItem.implicitHeight + divider.implicitHeight)

            Layout.alignment: Qt.AlignTop

            Text {
                id: title
                text: "Bluetooth"
                font: StylizedFont.title
                color: Colors.md3.on_surface
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Rectangle {
                id: divider
                implicitWidth: parent.width * 0.8
                implicitHeight: 1
                color: Colors.md3.on_surface_variant
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: title.bottom
            }
            Item {
                id: stateItem

                implicitWidth: icon.implicitWidth
                implicitHeight: icon.implicitHeight

                IconButton {
                    id: icon
                    source: Bluetooth.statusIcon
                    backgroundColor: stateHover.hovered ? Colors.md3.secondary_container : (Bluetooth.defaultAdapter.enabled ? Colors.md3.primary_container : Colors.md3.surface_variant)
                    iconColor: stateHover.hovered ? Colors.md3.on_secondary_container : (Bluetooth.defaultAdapter.enabled ? Colors.md3.on_primary_container : Colors.md3.on_surface_variant)

                    Behavior on backgroundColor {
                        ColorAnimation {
                            duration: Config.animMs
                            easing.type: Easing.InOutQuad
                        }
                    }

                    Behavior on iconColor {
                        ColorAnimation {
                            duration: Config.animMs
                            easing.type: Easing.InOutQuad
                        }
                    }
                }

                HoverHandler {
                    id: stateHover
                    cursorShape: Qt.PointingHandCursor
                }

                TapHandler {
                    id: stateTap
                    acceptedButtons: Qt.LeftButton
                    onTapped: {
                        // Needs if statement otherwise can desync with service
                        if (Bluetooth.defaultAdapter)
                            Bluetooth.defaultAdapter.enabled = !Bluetooth.defaultAdapter.enabled;
                    }
                }
            }

            Item {
                id: searchItem
                implicitWidth: searchIcon.implicitWidth
                implicitHeight: searchIcon.implicitHeight

                anchors.right: parent.right

                IconButton {
                    id: searchIcon
                    source: Qt.resolvedUrl(Quickshell.shellPath("modules/img/launcher/search.svg"))
                    backgroundColor: searchHover.hovered ? Colors.md3.secondary_container : (Bluetooth.defaultAdapter.discovering ? Colors.md3.primary_container : Colors.md3.surface_variant)
                    iconColor: searchHover.hovered ? Colors.md3.on_secondary_container : (Bluetooth.defaultAdapter.discovering ? Colors.md3.on_primary_container : Colors.md3.on_surface_variant)

                    Behavior on backgroundColor {
                        ColorAnimation {
                            duration: Config.animMs
                            easing.type: Easing.InOutQuad
                        }
                    }

                    Behavior on iconColor {
                        ColorAnimation {
                            duration: Config.animMs
                            easing.type: Easing.InOutQuad
                        }
                    }
                }

                HoverHandler {
                    id: searchHover
                    cursorShape: Qt.PointingHandCursor
                }

                TapHandler {
                    id: searchTap
                    acceptedButtons: Qt.LeftButton
                    onTapped: {
                        if (Bluetooth.defaultAdapter && !Bluetooth.defaultAdapter.discovering) {
                            discoverTimer.start();
                            Bluetooth.defaultAdapter.discovering = true;
                        }
                        else
                            Bluetooth.defaultAdapter.discovering = false;
                    }
                }
            }
        }

        ListView {
            id: deviceListView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: Config.spaceSm
            model: Bluetooth.devices

            delegate: Rectangle {
                id: delegate
                required property var modelData
                implicitWidth: ListView.view.width
                implicitHeight: row.implicitHeight + Config.spaceSm * 2
                color: delegateHover.hovered ? Colors.md3.surface_variant : Colors.md3.surface
                radius: Config.radiusBox

                Behavior on color {
                    ColorAnimation {
                        duration: Config.animMs
                        easing.type: Easing.InOutQuad
                    }
                }

                HoverHandler {
                    id: delegateHover
                }

                RowLayout {
                    id: row
                    anchors.fill: parent
                    anchors.margins: Config.spaceSm
                    spacing: Config.spaceSm

                    IconImage {
                        id: deviceIcon
                        source: Quickshell.iconPath(delegate.modelData.icon, true)
                        implicitSize: Config.iconSize
                        Layout.alignment: Qt.AlignVCenter
                    }

                    Text {
                        id: nameText
                        text: delegate.modelData.batteryAvailable ? delegate.modelData.battery + "% " + delegate.modelData.deviceName : delegate.modelData.deviceName
                        font: StylizedFont.body
                        color: Colors.md3.on_surface
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                        elide: Text.ElideRight
                    }

                    RowLayout {
                        Layout.alignment: Qt.AlignVCenter

                        PillShape {
                            id: pairingButton

                            Layout.alignment: Qt.AlignVCenter

                            color: pairingButtonHover.hovered ? Colors.md3.secondary_container : Colors.md3.tertiary_container

                            Text {
                                text: {
                                    if (delegate.modelData.pairing)
                                        return "Pairing...";
                                    if (delegate.modelData.paired && !delegate.modelData.bonded)
                                        return "Bonding...";
                                    return delegate.modelData.paired ? "Unpair" : "Pair";
                                }
                                color: pairingButtonHover.hovered ? Colors.md3.on_secondary_container : Colors.md3.on_tertiary_container
                            }
                            onTapped: {
                                if (delegate.modelData.paired)
                                    Bluetooth.pairDevice(delegate.modelData);
                                else
                                    Bluetooth.pairDevice(delegate.modelData);
                            }

                            HoverHandler {
                                id: pairingButtonHover
                                cursorShape: Qt.PointingHandCursor
                            }
                        }

                        PillShape {
                            id: connectButton
                            Layout.alignment: Qt.AlignVCenter
                            opacity: (delegate.modelData.paired && delegate.modelData.bonded && !delegate.modelData.pairing) ? 1 : 0
                            visible: opacity > 0

                            color: connectButtonHover.hovered ? Colors.md3.secondary_container : (delegate.modelData.connected ? Colors.md3.primary_container : Colors.md3.tertiary_container)

                            Text {
                                text: delegate.modelData.connecting ? "Connecting..." : (delegate.modelData.connected ? "Disconnect" : "Connect")
                                color: connectButtonHover.hovered ? Colors.md3.on_secondary_container : (delegate.modelData.connected ? Colors.md3.on_primary_container : Colors.md3.on_tertiary_container)
                                Behavior on color {
                                    ColorAnimation {
                                        duration: Config.animMs
                                        easing.type: Easing.InOutQuad
                                    }
                                }
                            }
                            onTapped: {
                                if (delegate.modelData.connected)
                                    Bluetooth.connectDevice(delegate.modelData);
                                else
                                    Bluetooth.connectDevice(delegate.modelData);
                            }

                            Behavior on color {
                                ColorAnimation {
                                    duration: Config.animMs
                                    easing.type: Easing.InOutQuad
                                }
                            }

                            HoverHandler {
                                id: connectButtonHover
                                cursorShape: Qt.PointingHandCursor
                            }
                        }
                    }
                }
            }
        }
    }
    IpcHandler {
        id: ipcHandler
        target: "bluetooth"
        function toggle() {
            root.visible = !root.visible;
        }
    }
}
