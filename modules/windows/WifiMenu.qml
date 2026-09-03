pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Networking
import Quickshell.Io
import qs.theme
import qs.services
import qs.config

// Wifi Menu Window
Window {
    id: root
    title: "Wifi Manager"
    width: 420
    height: 520
    visible: false
    color: Colors.md3.surface

    onVisibleChanged: {
        if (visible) {
            Networks.clearSeen();
            Networks.kickScan();
        }
    }

    Timer {
        interval: 8000
        running: root.visible
        repeat: true
        onTriggered: Networks.kickScan()
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Config.spaceMd
        spacing: Config.spaceMd

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: "Wifi Manager"
            color: Colors.md3.on_surface
            font: StylizedFont.title
        }

        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: parent.width * 0.8
            height: 1
            color: Colors.md3.surface_variant
        }

        RowLayout {
            Layout.fillWidth: true

            Text {
                text: "WIFI"
                color: Colors.md3.on_surface
                font: StylizedFont.bold
            }
            Item {
                Layout.fillWidth: true
            }

            Switch {
                id: wifiSwitch

                property bool latched: Networking.wifiEnabled

                checked: latched
                enabled: Networking.wifiHardwareEnabled

                Behavior on latched  {
                    NumberAnimation {
                        duration: Config.animMs
                        easing.type: Easing.InOutQuad
                    }
                }
                
                onToggled: {
                    Networking.wifiEnabled = checked;
                    latched = checked;
                }

                Connections {
                    target: Networking
                    function onWifiEnabledChanged() {
                        wifiSwitch.latched = Networking.wifiEnabled;
                    }
                }

                implicitWidth: 48
                implicitHeight: 24

                indicator: Rectangle {
                    implicitWidth: wifiSwitch.implicitWidth
                    implicitHeight: wifiSwitch.implicitHeight
                    radius: Config.radiusPill
                    color: wifiSwitch.checked ? Colors.md3.primary : Colors.md3.on_surface_variant

                    Behavior on color {
                        ColorAnimation {
                            duration: Config.animMs
                            easing.type: Easing.InOutQuad
                        }
                    }

                    Rectangle {
                        width: 20
                        height: 20
                        radius: Config.radiusPill
                        anchors.verticalCenter: parent.verticalCenter
                        x: 4 + wifiSwitch.visualPosition * (parent.width - width - 8)
                        color: wifiSwitch.checked ? Colors.md3.on_primary : Colors.md3.outline

                        Behavior on x {
                            NumberAnimation {
                                duration: Config.animMs
                                easing.type: Easing.InOutQuad
                            }
                        }
                    }
                }
            }
        }

        Text {
            visible: !!Networks.connectedWifi
            text: "Connected: " + (Networks.connectedWifi?.name ?? "")
            color: Colors.md3.primary
            font: StylizedFont.bold
        }

        ListView {
            id: listView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: Config.spaceSm
            model: Networks.nearbyNetworks

            delegate: Rectangle {
                id: delegate
                required property var modelData
                width: ListView.view.width
                implicitHeight: row.implicitHeight + Config.spaceSm * 2
                radius: Config.radiusBox
                opacity: modelData.net ? 1 : 0.55
                color: modelData.connected ? Colors.md3.primary_container : Colors.md3.surface_variant

                RowLayout {
                    id: row
                    anchors.fill: parent
                    anchors.margins: Config.spaceSm
                    spacing: Config.spaceSm

                    ColumnLayout {
                        spacing: 0

                        Text {
                            text: delegate.modelData.name + " " + Math.round(delegate.modelData.signalStrength * 100) + "%" + (delegate.modelData.known ? " · saved" : "")
                            color: Colors.md3.on_surface_variant
                            font: StylizedFont.tooltip
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    RoundButton {
                        visible: delegate.modelData.net && !delegate.modelData.connected
                        text: "Connect"
                        onClicked: {
                            Networks.connectTo(delegate.modelData.net);
                        }
                    }

                    RoundButton {
                        visible: delegate.modelData.net && delegate.modelData.connected
                        text: "Disconnect"
                        onClicked: delegate.modelData.disconnect()
                    }
                }

                Connections {
                    target: delegate.modelData.net
                    enabled: delegate.modelData.net !== null
                    ignoreUnknownSignals: true
                    function onConnectionFailed(reason) {
                        if (reason === ConnectionFailReason.NoSecrets)
                            psk.network = delegate.modelData.net;
                    }
                }
            }
        }

        RowLayout {
            visible: psk.network !== null
            Layout.fillWidth: true
            TextField {
                id: pskField
                Layout.fillWidth: true
                echoMode: TextInput.Password
                placeholderText: "Password"
            }

            RoundButton {
                text: "Join"
                onClicked: {
                    Networks.connectTo(psk.network, pskField.text);
                    psk.network = null;
                    pskField.text = "";
                }
            }
        }
    }

    Binding {
        target: Networks.wirelessDevice
        property: "scannerEnabled"
        value: true
        when: root.visible && Networks.wirelessDevice !== null
    }

    QtObject {
        id: psk
        property var network: null
    }

    IpcHandler {
        id: ipc
        target: "wifi"

        function toggle() {
            root.visible = true;
        }
    }
}
