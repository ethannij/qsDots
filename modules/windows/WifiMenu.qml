import QtQuick
import QtQuick.Layouts
import Quickshell.Networking
import qs.theme
import qs.services
import qs.config
import qs.modules.elements

// Wifi Menu
Item {
    id: root
    visible: PillController.wifiOpen

    // Scan when menu is shown
    onVisibleChanged: {
        if (visible)
            Networks.kickScan();
        else
            Networks.pskSsid = "";
    }

    // Double check scanner is turned on assuming a wifi device exists
    Binding {
        target: Networks.wirelessDevice
        property: "scannerEnabled"
        value: true
        when: root.visible && Networks.wirelessDevice !== null
    }

    // UI bits *Caution* this whole block is a nightmare, I've attempted to clean it up but its a mess
    ColumnLayout {
        id: ui
        anchors.fill: parent
        anchors.margins: Config.spaceMd
        spacing: Config.spaceMd

        Item {
            // Includes title and state as well as divider
            id: header
            implicitWidth: parent.width
            implicitHeight: Math.max(title.implicitHeight + divider.implicitHeight, stateItem.implicitHeight + divider.implicitHeight)

            Layout.alignment: Qt.AlignTop

            Text {
                id: title
                text: "Wifi"
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
                // Same as bluetooth, toggle wifi on and off or right click to close
                id: stateItem
                implicitWidth: icon.implicitWidth
                implicitHeight: icon.implicitHeight

                IconButton {
                    id: icon
                    source: Networks.statusIcon
                    backgroundColor: stateHovered.hovered ? Colors.md3.secondary_container : (Networks.wifiEnabled ? Colors.md3.primary_container : Colors.md3.surface_variant)
                    iconColor: stateHovered.hovered ? Colors.md3.on_secondary_container : (Networks.wifiEnabled ? Colors.md3.on_primary_container : Colors.md3.on_surface_variant)

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
                    id: stateHovered
                    cursorShape: Qt.PointingHandCursor
                }

                TapHandler {
                    id: stateTap
                    onTapped: {
                        // Toggle wifi state
                        Networks.toggleWifi();
                    }
                }

                TapHandler {
                    id: stateTapAlternate
                    acceptedButtons: Qt.RightButton

                    // Close wifi and return to panel
                    onTapped: {
                        PillController.closeWifi();
                        PillController.showPanel();
                    }
                }
            }
        }

        ListView {
            // List of networks as well as connect/disconnect buttons and psk prompt
            id: wifiListView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: Config.spaceSm
            model: Networks.nearbyNetworks

            delegate: Rectangle {
                // Last chance to turn back
                id: delegate
                required property var modelData
                implicitWidth: ListView.view.width
                implicitHeight: row.implicitHeight + Config.spaceSm * 2
                color: delegateHover.hovered ? Colors.md3.surface_variant : Colors.md3.surface
                radius: Config.radiusBox

                // These bits are used to determine if psk is needed and if prompt is shown
                property bool askingPsk: false
                readonly property bool needsPsk: {
                    const s = modelData.net?.security ?? modelData.security;
                    return s !== undefined && s !== WifiSecurityType.Open && s !== WifiSecurityType.Owe;
                }

                // Determines if psk is needed and prompts
                Connections {
                    target: delegate.modelData.net
                    enabled: delegate.modelData.net !== null
                    ignoreUnknownSignals: true
                    function onConnectionFailed(reason) {
                        if (reason === ConnectionFailReason.NoSecrets)
                            Networks.pskSsid = delegate.modelData.name;
                    }
                }

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

                    TapHandler {
                        // Left click another list item to clear psk prompt
                        acceptedButtons: Qt.LeftButton
                        onTapped: {
                            if (Networks.pskSsid === delegate.modelData.name)
                                Networks.pskSsid = "";
                        }
                    }

                    ColorizedIcon {
                        // Self explanatory, shows signal strength of a given network
                        id: signalIcon
                        source: Networks.signalIcon(delegate.modelData.signalStrength)
                        size: Config.iconSize
                        Layout.alignment: Qt.AlignVCenter
                    }

                    Text {
                        id: nameText
                        text: delegate.modelData.name
                        font: StylizedFont.body
                        color: Colors.md3.on_surface
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                        elide: Text.ElideRight
                    }

                    RowLayout {
                        // Handles buttons and psk prompt per network
                        id: actions
                        Layout.alignment: Qt.AlignVCenter
                        spacing: Config.spaceSm
                        readonly property bool showPsk: Networks.pskSsid === delegate.modelData.name

                        PillShape {
                            interactive: false

                            color: Colors.md3.surface_variant
                            opacity: actions.showPsk ? 1 : 0
                            visible: opacity > 0
                            enabled: actions.showPsk

                            TextInput {
                                // Input for psk
                                id: pskInput

                                // Formatting
                                width: actions.showPsk ? 120 : 0
                                height: nameText.implicitHeight
                                clip: true
                                echoMode: TextInput.Password

                                // Styling
                                selectionColor: Colors.md3.primary
                                selectedTextColor: Colors.md3.on_primary
                                font: StylizedFont.body
                                color: Colors.md3.on_surface_variant

                                // Behaviors
                                onVisibleChanged: if (visible)
                                    forceActiveFocus()

                                onAccepted: {
                                    Networks.connectTo(delegate.modelData.net, text);
                                    text = "";
                                    Networks.pskSsid = "";
                                }
                                Keys.onEscapePressed: {
                                    text = "";
                                    Networks.pskSsid = "";
                                }
                            }

                            // Animations for prompt
                            Behavior on opacity {
                                NumberAnimation {
                                    duration: Config.animMs
                                    easing.type: Easing.InOutQuad
                                }
                            }

                            Behavior on implicitWidth {
                                NumberAnimation {
                                    duration: Config.animMs
                                    easing.type: Easing.InOutQuad
                                }
                            }
                        }

                        PillShape {
                            // Connect/Disconnect Button
                            id: connectButton

                            // Formatting, not size/width, static text means pillshape can determine that itself
                            visible: opacity > 0
                            enabled: !actions.showPsk
                            opacity: actions.showPsk ? 0 : 1
                            clip: true

                            //Styling
                            color: connectButtonHover.hovered ? Colors.md3.secondary_container : Colors.md3.tertiary_container

                            // Text based on connection state, dedicated property so we can animate on change
                            readonly property string statusText: {
                                if (delegate.modelData.connected)
                                    return "Disconnect";
                                if (delegate.modelData.net?.state === ConnectionState.Connecting)
                                    return "Connecting...";
                                return "Connect";
                            }

                            property string shownText: statusText

                            // When status text changes, animate the text swap
                            onStatusTextChanged: {
                                if (shownText === statusText)
                                    return;
                                textSwap.restart();
                            }

                            // Animation for text swap
                            SequentialAnimation {
                                id: textSwap
                                NumberAnimation {
                                    // First part of animation, fade existing text out
                                    target: connectLabel
                                    property: "opacity"
                                    to: 0
                                    duration: Config.animMs / 2
                                    easing.type: Easing.InOutQuad
                                }

                                // Set the new text
                                ScriptAction {
                                    script: connectButton.shownText = connectButton.statusText
                                }

                                NumberAnimation {
                                    // Second part of animation, fade new text in
                                    target: connectLabel
                                    property: "opacity"
                                    to: 1
                                    duration: Config.animMs / 2
                                    easing.type: Easing.InOutQuad
                                }
                            }

                            // Classic animations for size and color change
                            Behavior on implicitWidth {
                                NumberAnimation {
                                    duration: Config.animMs
                                    easing.type: Easing.InOutQuad
                                }
                            }

                            Behavior on implicitHeight {
                                NumberAnimation {
                                    duration: Config.animMs
                                    easing.type: Easing.InOutQuad
                                }
                            }

                            Behavior on color {
                                ColorAnimation {
                                    duration: Config.animMs
                                    easing.type: Easing.InOutQuad
                                }
                            }

                            // Text within pill
                            Text {
                                id: connectLabel
                                text: connectButton.shownText
                                color: connectButtonHover.hovered ? Colors.md3.on_secondary_container : Colors.md3.on_tertiary_container
                                font: StylizedFont.body

                                Behavior on color {
                                    ColorAnimation {
                                        duration: Config.animMs
                                        easing.type: Easing.InOutQuad
                                    }
                                }
                            }

                            onTapped: {
                                // When tapped, first we check if its a connect or disconnect
                                if (delegate.modelData.connected) {
                                    Networks.disconnectNetwork(delegate.modelData.net);
                                    return;
                                }
                                // If the network doesnt exist, do nothing
                                if (!delegate.modelData.net)
                                    return;
                                // If network is known and password is not needed/saved, connect
                                if (delegate.modelData.known || !delegate.needsPsk)
                                    Networks.connectTo(delegate.modelData.net);
                                else
                                    // Last ditch effort, prompt for psk
                                    Networks.pskSsid = delegate.modelData.name;
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
}
