import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Pam
import Quickshell.Io
import QtQuick
import QtQuick.Effects
import QtQuick.Controls
import qs.services
import qs.modules
import qs.modules.elements
import qs.theme
import qs.config

Item {
    id: root

    // Functions to lock and unlock
    function lock() {
        if (locked || arming)
            return;
        arming = true
        PillController.pillLock = true;
        armTimer.restart();
    }

    function unlock() {
        if (!locked || closing)
            return;
        closing = true;
        arming = false;
    }

    // Release lockscreen post animation
    function finishUnlock() {
        if (!locked || releasing)
            return;
        releasing = true;
        covering = false;
        closing = false;
        Qt.callLater(() => {
            root.locked = false;
            root.releasing = false;
        });
        pillUnlockTimer.restart();
    }

    // Timer to arm the lock, gives a moment to animate the pill into its default shape
    Timer {
        id: armTimer
        interval: Config.animMs
        onTriggered: root.locked = true
    }

    // Unlock the pill and fade back into normal
    Timer {
        id: pillUnlockTimer
        interval: Config.animMs
        repeat: false
        running: false
        onTriggered: {
            PillController.pillLock = false;
        }
    }

    // IPC handlers for apps to call lockscreen
    IpcHandler {
        id: ipc
        target: "lockscreenIpc"

        function lock(): void {
            root.lock();
        }

        function unlock(): void {
            root.unlock();
        }
    }

    // Boilerplate properties
    property alias locked: lock.locked
    property bool arming: false

    // Animation states
    property bool closing: false
    property bool releasing: false
    property bool covering: false
    property real clockShift: 0

    // Sizing
    property real barWidth: 0
    property real barHeight: 0

    // Covering the lockscreen when unlocked
    onLockedChanged: if (!locked) {
        covering = false;
        PillController.pillLock = false;
    } else if (locked) {
        PillController.pillLock = true;
    }

    // Timer to finish unlock while closing = true
    Timer {
        id: unlockFallback
        interval: 800
        onTriggered: {
            if (!root.closing)
                return;
            root.finishUnlock();
        }
    }

    // The actual lock surface
    WlSessionLock {
        id: lock

        WlSessionLockSurface {
            id: surface
            color: "transparent"

            // When lockscreen appears, focus input field (for typing password)
            onVisibleChanged: if (visible)
                input.forceActiveFocus()

            // PAM context for password authentication | more boilerplate
            PamContext {
                id: pam
                configDirectory: Quickshell.shellPath("pam")
                config: "password.conf"

                onPamMessage: {
                    if (responseRequired)
                        respond(input.text);
                }
                onCompleted: result => {
                    if (result === PamResult.Success) {
                        root.unlock();
                        return;
                    }
                    pill.notice = "Invalid Password";
                    pill.noticeColor = Colors.md3.error;
                    pill.holdPrompt = true;
                    input.clear();
                    promptTimer.restart();
                }
            }

            // Send password through PAM to attempt an unlock
            function tryUnlock() {
                if (input.text.length === 0 || pam.active)
                    return;
                pill.notice = "Checking...";
                pill.noticeColor = Colors.md3.on_surface_variant;
                pam.start();
            }

            // Lockscreen Wallpaper + Elements
            Item {
                anchors.fill: parent
                clip: true
                opacity: lockPill.open

                // Chosen Wallpaper
                Image {
                    id: wall
                    source: Colors.wallpaper
                    fillMode: Image.PreserveAspectCrop

                    // Zoom image in so we can drift it
                    width: parent.width * 1.2
                    height: parent.height * 1.3

                    // Drift image
                    x: (parent.width - width) * drift
                    y: (parent.height - height) * drift

                    property real drift: 0 // Image is zoomed in slightly and will move around when locked

                    SequentialAnimation on drift {
                        loops: Animation.Infinite
                        NumberAnimation {
                            from: 0.5
                            to: 0.8
                            duration: 180000
                            easing.type: Easing.InOutCubic
                        }
                        NumberAnimation {
                            from: 0.8
                            to: 0.3
                            duration: 180000
                            easing.type: Easing.InOutCubic
                        }
                    }

                    // Blur lockscreen wallpaper
                    layer.enabled: true
                    layer.effect: MultiEffect {
                        blurEnabled: true
                        blur: 1
                        blurMax: 64
                    }
                }
            }

            // Blurred overlay
            Rectangle {
                anchors.fill: parent
                color: Colors.md3.surface
                opacity: 0.3 * lockPill.open
            }

            // The animated Pill
            Item {
                id: lockPill

                // Pill animation definitions, similar to morphPill
                property real open: 0
                property real faceW: pill.implicitWidth
                property real faceH: pill.implicitHeight
                readonly property real fromW: root.barWidth > 0 ? root.barWidth : faceW
                readonly property real fromH: root.barHeight > 0 ? root.barHeight : faceH
                width: fromW + (faceW - fromW) * open
                height: fromH + (faceH - fromH) * open

                Behavior on faceW {
                    NumberAnimation {
                        duration: Config.animMs
                        easing.type: Easing.InOutCubic
                    }
                }
                Behavior on faceH {
                    NumberAnimation {
                        duration: Config.animMs
                        easing.type: Easing.InOutCubic
                    }
                }
                x: (parent.width - width) / 2
                y: Config.barMarginV + open * ((parent.height - height * scale) / 2 - Config.barMarginV)
                scale: 1 + open * 0.8
                transformOrigin: Item.Center
                Behavior on open {
                    NumberAnimation {
                        id: openAnim
                        duration: 700
                        easing.type: Easing.InOutCubic
                        onRunningChanged: {
                            if (openAnim.running || !root.closing || lockPill.open > 0)
                                return;
                            Qt.callLater(root.finishUnlock);
                        }
                    }
                }

                // Connections to finish unlock while closing = true
                Connections {
                    target: root
                    function onClosingChanged() {
                        if (!root.closing)
                            return;
                        pill.notice = "";
                        pill.holdPrompt = false;
                        input.clear();
                        unlockFallback.restart();
                        if (lockPill.open === 0) {
                            root.finishUnlock();
                            return;
                        }
                        lockPill.open = 0;
                    }
                }

                // Shadow for the Pill, same as morphPill
                RectangularShadow {
                    id: shadow
                    anchors.fill: pill
                    visible: !Gamemode.active
                    color: Colors.md3.shadow
                    radius: 100
                    spread: 4
                    blur: 10
                    opacity: 0.7
                    offset: Qt.point(0, 1)
                }

                // When lockscreen appears, cover it
                Component.onCompleted: {
                    root.covering = true;
                    open = 1;
                }

                // The interactive Pill
                PillShape {
                    id: pill
                    clip: true
                    anchors.fill: parent
                    hasBorder: OLED.active ? false : true
                    radius: Gamemode.active ? 0 :height / 2
                    borderWidth: OLED.active || Gamemode.active ? Config.borderWidth : 0
                    borderColor: OLED.active || Gamemode.active ? Colors.md3.outline_variant : "transparent"

                    property bool holdPrompt: false
                    property string notice: ""
                    property color noticeColor: Colors.md3.on_surface_variant
                    readonly property bool editing: input.text.length > 0 || holdPrompt || notice !== ""
                    readonly property bool fieldFits: width >= promptMeasure.implicitWidth + padH * 2 - 1

                    // Timer to clear notice after 5 seconds
                    Timer {
                        id: promptTimer
                        interval: 5000
                        onTriggered: {
                            pill.holdPrompt = false;
                            pill.notice = "";
                        }
                    }

                    // The clock and prompt container
                    Item {
                        implicitWidth: pill.editing ? promptMeasure.implicitWidth : clock.implicitWidth
                        implicitHeight: Math.max(clock.implicitHeight, promptMeasure.implicitHeight)
                        transform: Translate {
                            x: root.clockShift * (1 - lockPill.open)
                        }

                        // Measure the prompt text for sizing
                        Text {
                            id: promptMeasure
                            visible: false
                            text: "Enter Password..."
                            font: StylizedFont.body
                        }

                        // The clock text
                        Text {
                            id: clock
                            anchors.centerIn: parent
                            text: Qt.formatDateTime(Time.date, Config.clockFormat)
                            font: StylizedFont.bold
                            color: Colors.md3.on_surface_variant
                            opacity: pill.editing ? 0 : 1
                            Behavior on opacity {
                                NumberAnimation {
                                    duration: Config.animMs / 2
                                    easing.type: Easing.OutCubic
                                }
                            }
                        }

                        // The prompt text
                        Text {
                            id: prompt
                            anchors.centerIn: parent
                            text: pill.notice !== "" ? pill.notice : "Enter Password..."
                            font: promptMeasure.font
                            color: pill.notice !== "" ? pill.noticeColor : Colors.md3.on_surface_variant
                            opacity: pill.fieldFits && (pill.notice !== "" || (pill.holdPrompt && input.text.length === 0)) ? 1 : 0
                            Behavior on opacity {
                                NumberAnimation {
                                    duration: 140
                                    easing.type: Easing.OutCubic
                                }
                            }
                            Behavior on color {
                                ColorAnimation {
                                    duration: 140
                                }
                            }
                        }

                        // The input field
                        TextField {
                            id: input
                            anchors.centerIn: parent
                            width: promptMeasure.implicitWidth
                            font: promptMeasure.font
                            echoMode: TextInput.Password
                            opacity: text.length > 0 && pill.fieldFits && pill.notice === "" ? 1 : 0
                            color: Colors.md3.on_surface
                            Behavior on opacity {
                                NumberAnimation {
                                    duration: 140
                                    easing.type: Easing.OutCubic
                                }
                            }
                            background: null
                            onAccepted: surface.tryUnlock()
                            onTextChanged: {
                                if (text.length > 0) {
                                    pill.holdPrompt = true;
                                    pill.notice = "";
                                    promptTimer.stop();
                                } else if (pill.holdPrompt) {
                                    promptTimer.restart();
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
