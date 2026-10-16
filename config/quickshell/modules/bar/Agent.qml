import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick
import QtQuick.Controls
import qs.services
import qs.modules.elements
import qs.theme
import qs.config

PillShape {
    id: root

    property bool historyShown: Agents.messages.length > 0
    property bool animateHistory: false
    property int reveal: 0

    function linesOf(content) {
        const max = 800;
        const out = [];
        const parts = String(content).split("\n");
        for (let p = 0; p < parts.length; ++p) {
            const part = parts[p];
            if (part.length <= max) {
                out.push(part);
                continue;
            }
            let rest = part;
            if (rest.length > 0)
                out.push(rest);
        }
        return out;
    }

    Timer {
        id: typer
        interval: 110
        repeat: true
        onTriggered: {
            const last = Agents.messages[Agents.messages.length - 1];
            if (!last || last.role !== "assistant") {
                stop();
                return;
            }
            if (root.reveal >= root.linesOf(last.content).length) {
                stop();
                return;
            }
            root.reveal += 1;
        }
    }

    Connections {
        target: Agents
        function onMessagesChanged() {
            const last = Agents.messages[Agents.messages.length - 1];
            if (!last || last.role !== "assistant")
                return;
            root.reveal = 1;
            typer.start();
        }
    }

    Column {
        spacing: Config.spaceSm

        Item {
            id: chatHistory
            width: chatInput.width
            height: root.historyShown ? Math.min(transcript.implicitHeight, 400) : 0
            clip: true
            visible: opacity > 0
            opacity: root.historyShown && height > 0 ? 1 : 0

            Behavior on height {
                enabled: root.animateHistory
                NumberAnimation {
                    duration: Config.animMs
                    easing.type: Easing.InOutCubic
                    onFinished: root.animateHistory = false
                }
            }
            Behavior on opacity {
                NumberAnimation {
                    duration: Config.animMs
                    easing.type: Easing.InOutCubic
                }
            }
            Flickable {
                id: scroller
                anchors.fill: parent
                contentWidth: width
                contentHeight: transcript.implicitHeight
                flickableDirection: Flickable.VerticalFlick
                clip: true

                function follow() {
                    contentY = Math.max(0, contentHeight - height);
                }
                onContentHeightChanged: if (root.historyShown)
                    follow()
                onHeightChanged: if (root.historyShown)
                    follow()

                Column {
                    id: transcript
                    width: parent.width
                    spacing: Config.spaceSm
                    Repeater {
                        model: Agents.messages
                        delegate: Item {
                            id: bubble
                            required property var modelData
                            required property int index
                            readonly property bool fromUser: modelData.role === "user"
                            readonly property bool streaming: !fromUser && index === Agents.messages.length - 1
                            readonly property var lines: root.linesOf(modelData.content)
                            readonly property int shown: streaming ? Math.min(root.reveal, lines.length) : lines.length
                            width: transcript.width
                            height: fromUser ? label.implicitHeight : block.implicitHeight

                            function joinLines(from, to) {
                                let text = "";
                                for (let i = from; i < to && i < lines.length; ++i) {
                                    if (text !== "")
                                        text += "\n";
                                    text += lines[i];
                                }
                                return text;
                            }

                            Text {
                                id: label
                                visible: fromUser
                                width: chatHistory.width
                                wrapMode: Text.WordWrap
                                horizontalAlignment: Text.AlignLeft
                                color: Colors.md3.tertiary
                                text: Quickshell.env("USER") + ": " + modelData.content
                            }
                            Column {
                                id: block
                                visible: !fromUser
                                width: chatHistory.width
                                spacing: 0

                                Text {
                                    width: chatHistory.width
                                    wrapMode: Text.WordWrap
                                    horizontalAlignment: Text.AlignLeft
                                    color: Colors.md3.on_surface
                                    text: bubble.joinLines(0, bubble.streaming ? Math.max(0, bubble.shown - 1) : bubble.shown)
                                }
                                Text {
                                    id: fresh
                                    width: chatHistory.width
                                    wrapMode: Text.WordWrap
                                    horizontalAlignment: Text.AlignLeft
                                    color: Colors.md3.on_surface
                                    text: bubble.streaming && bubble.shown > 0 ? bubble.lines[bubble.shown - 1] : ""

                                    NumberAnimation {
                                        id: fade
                                        target: fresh
                                        property: "opacity"
                                        from: 0
                                        to: 1
                                        duration: 260
                                        easing.type: Easing.OutCubic
                                    }
                                    onTextChanged: {
                                        if (text !== "")
                                            fade.start();
                                    }
                                }
                            }
                        }
                    }
                    Text {
                        width: chatHistory.width * 0.55
                        x: chatHistory.width - width
                        horizontalAlignment: Text.AlignRight
                        visible: Agents.busy
                        text: ".".repeat(thinking.step)
                        color: Colors.md3.on_surface
                        Timer {
                            id: thinking
                            property int step: 1
                            interval: 400
                            repeat: true
                            running: Agents.busy
                            onTriggered: step = step % 3 + 1
                            onRunningChanged: if (running)
                                step = 1
                        }
                    }
                }
            }
        }

        Row {
            spacing: Config.spaceMd

            ColorizedIcon {
                source: Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/agent/ai.svg"))
                color: iconHover.hovered ? Colors.md3.primary : Colors.md3.on_surface
                anchors.top: parent.top
                HoverHandler {
                    id: iconHover
                    cursorShape: Qt.PointingHandCursor
                }

                TapHandler {
                    id: iconTap
                    onTapped: {
                        PillController.releaseAgent();
                    }
                }

                Behavior on color {
                    ColorAnimation {
                        duration: Config.animMs
                        easing.type: Easing.InOutCubic
                    }
                }
            }

            TextField {
                id: chatInput
                anchors.verticalCenter: parent.verticalCenter
                placeholderText: "Ask me anything!"
                width: Math.max(implicitWidth, 960)
                wrapMode: TextEdit.Wrap
                font: StylizedFont.body
                color: Colors.md3.on_surface
                focus: true
                onAccepted: {
                    Agents.send(chatInput.text);
                    chatInput.clear();
                    root.animateHistory = true;
                    root.historyShown = true;
                }
                onEnabledChanged: {
                    if (enabled)
                        chatInput.forceActiveFocus();
                    else
                        chatInput.clear();
                }

                Keys.onShortcutOverride: event => {
                    event.accepted = (event.key === Qt.Key_Escape);
                }

                Keys.onEscapePressed: event => {
                    event.accepted = true;
                    PillController.releaseAgent();
                }

                background: Rectangle {
                    border.width: 0
                    color: "transparent"
                    radius: Config.radiusPill
                }
            }

            ColorizedIcon {
                source: Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/agent/submit.svg"))
                anchors.bottom: chatInput.bottom
                color: submitHover.hovered ? Colors.md3.primary : Colors.md3.on_surface

                HoverHandler {
                    id: submitHover
                    cursorShape: Qt.PointingHandCursor
                }

                TapHandler {
                    id: submitTap
                    onTapped: {
                        Agents.send(chatInput.text);
                        chatInput.clear();
                        root.animateHistory = true;
                        root.historyShown = true;
                    }
                }

                Behavior on color {
                    ColorAnimation {
                        duration: Config.animMs
                        easing.type: Easing.InOutCubic
                    }
                }
            }

            ColorizedIcon {
                source: chatHistory.visible ? Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/agent/arrow_up.svg")) : Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/agent/arrow_down.svg"))
                color: arrowHover.hovered ? Colors.md3.primary : Colors.md3.on_surface
                anchors.top: parent.top
                visible: Agents.messages.length > 0

                HoverHandler {
                    id: arrowHover
                    cursorShape: Qt.PointingHandCursor
                }

                TapHandler {
                    id: arrowTap
                    onTapped: {
                        root.animateHistory = true;
                        root.historyShown = !root.historyShown;
                    }
                }

                Behavior on color {
                    ColorAnimation {
                        duration: Config.animMs
                        easing.type: Easing.InOutCubic
                    }
                }
            }
        }
    }
}
