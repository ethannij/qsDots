import QtQuick
import QtQuick.Effects
import qs.modules.bar
import qs.services
import qs.modules.behaviors
import qs.theme
import qs.config
import qs.modules
import qs.modules.elements
import qs.modules.panel
import qs.modules.launcher
import qs.modules.windows

Item {
    id: morphPill

    readonly property real restHeight: clock.implicitHeight
    readonly property bool ready: restW > 0 && restH > 0
    readonly property bool gamebarOnly: PillController.activeFace === "gamebar"
    readonly property bool agentOnly: PillController.activeFace === "agent"
    readonly property bool pillLock: PillController.pillLock
    property alias dateShown: clock.showDate

    readonly property Item face: {
        switch (PillController.activeFace) {
        case "workspaces":
            return workspaces;
        case "volume":
            return volume;
        case "notification":
            return notification;
        case "gamebar":
            return gamebar;
        case "agent":
            return agent;
        default:
            return null;
        }
    }

    property real morph: PillController.overlay !== "none" ? 1 : 0

    // Animation when opening pill into overlay
    Behavior on morph {
        enabled: morphPill.ready && Config.animMs > 0
        NumberAnimation {
            duration: PillController.overlay !== "none" ? Config.animMs : Config.animMsClose
            easing.type: PillController.overlay !== "none" ? Easing[Config.animEasingOut] : Easing[Config.animEasingIn]
        }
    }

    property real hoverGrow: !morphPill.pillLock ? (hover.hovered && morph === 0 ? 8 : 0) : 0

    Behavior on hoverGrow {
        enabled: morphPill.ready && Config.animMs > 0
        NumberAnimation {
            duration: Config.animMs
            //easing.type: Config.animEasingOut.type
            easing.type: Easing[Config.animEasingOut]
        }
    }

    property real restW: 0
    property real restH: 0

    readonly property real liveRestW: restContent.implicitWidth + Config.shellPadH * 2
    readonly property real liveRestH: restContent.implicitHeight + Config.shellPadV * 2

    property string travelOverlay: "none"
    readonly property bool panelTravel: travelOverlay === "panel"
    // Stays on through the close so the row can fade back in after the shell is still.
    property bool fadeContent: false

    onLiveRestWChanged: if (morph === 0)
        restW = liveRestW

    onLiveRestHChanged: if (morph === 0)
        restH = liveRestH

    onMorphChanged: if (morph === 0) {
        restW = liveRestW;
        restH = liveRestH;
        const returning = travelOverlay === "panel";
        travelOverlay = "none";
        if (returning)
            contentFadeTimer.restart();
        else
            fadeContent = false;
    }

    Timer {
        id: contentFadeTimer
        interval: Config.animMs
        onTriggered: morphPill.fadeContent = false
    }

    onPillLockChanged: if (pillLock) {
        PillController.closePanel();
        PillController.faceHeld = false;
        PillController.dismiss();
    }

    function snapHostOpacity() {
        workspaces.opacity = PillController.activeFace === "workspaces" ? 1 : 0;
        volume.opacity = PillController.activeFace === "volume" ? 1 : 0;
        notification.opacity = PillController.activeFace === "notification" ? 1 : 0;
        gamebar.opacity = PillController.activeFace === "gamebar" ? 1 : 0;
        agent.opacity = PillController.activeFace === "agent" ? 1 : 0;
    }

    function runFaceAnim() {
        if (!ready || morph !== 0 || Config.animMs <= 0) {
            snapHostOpacity();
            return;
        }
        faceAnim.stop();
        wsOpAnim.to = PillController.activeFace === "workspaces" ? 1 : 0;
        volumeOpAnim.to = PillController.activeFace === "volume" ? 1 : 0;
        notifOpAnim.to = PillController.activeFace === "notification" ? 1 : 0;
        gamebarOpAnim.to = PillController.activeFace === "gamebar" ? 1 : 0;
        agentOpAnim.to = PillController.activeFace === "agent" ? 1 : 0;
        faceAnim.start();
    }

    // controlPanelH is the fixed size of the other overlays. The control panel
    // is shorter, and swapping to that fallback the frame it closes makes the
    // shell jump larger before it shrinks.
    property real travelH: Config.controlPanelH
    readonly property real livePanelH: panel.implicitHeight + Config.controlPanelPadding * 2
    readonly property real openH: panelTravel ? travelH : Config.controlPanelH

    onLivePanelHChanged: if (PillController.overlay === "panel" && livePanelH > 0)
        travelH = livePanelH

    readonly property real grow: panelTravel ? Math.max(morph - 0.22, 0) / 0.78 : morph

    width: restW + hoverGrow * (1 - morph) + (Config.controlPanelW - restW) * grow
    height: restH + hoverGrow * (1 - morph) + (openH - restH) * grow
    implicitWidth: width
    implicitHeight: height

    clip: false

    readonly property real clockShift: width > 0 && clock.width > 0 ? clock.mapToItem(morphPill, clock.width / 2, 0).x - width / 2 : 0
    readonly property real restOpacity: morph <= 0 ? 1 : morph >= 0.35 ? 0 : 1 - morph / 0.35
    readonly property real panelOpacity: morph <= 0.4 ? 0 : Math.min((morph - 0.4) / 0.6, 1)

    Component.onCompleted: {
        snapHostOpacity();
        restW = liveRestW;
        restH = liveRestH;
    }

    Connections {
        target: PillController
        function onActiveFaceChanged() {
            morphPill.runFaceAnim();
        }

        function onOverlayChanged() {
            if (PillController.overlay === "panel") {
                morphPill.fadeContent = true;
                morphPill.travelOverlay = "panel";
                if (morphPill.livePanelH > 0)
                    morphPill.travelH = morphPill.livePanelH;
            } else if (PillController.overlay !== "none") {
                morphPill.travelOverlay = PillController.overlay;
            }
        }
    }

    ParallelAnimation {
        id: faceAnim

        NumberAnimation {
            id: mediaChipOpAnim
            target: mediaChip
            property: "opacity"
            duration: !Media.isIdle ? Config.animMs : Config.animMsClose
            easing.type: !Media.isIdle ? Easing[Config.animEasingOut] : Easing[Config.animEasingIn]
        }

        NumberAnimation {
            id: wsOpAnim
            target: workspaces
            property: "opacity"
            duration: PillController.activeFace === "workspaces" ? Config.animMs : Config.animMsClose
            easing.type: PillController.activeFace === "workspaces" ? Easing[Config.animEasingOut] : Easing[Config.animEasingIn]
        }
        NumberAnimation {
            id: volumeOpAnim
            target: volume
            property: "opacity"
            duration: PillController.activeFace === "volume" ? Config.animMs : Config.animMsClose
            easing.type: PillController.activeFace === "volume" ? Easing[Config.animEasingOut] : Easing[Config.animEasingIn]
        }
        NumberAnimation {
            id: notifOpAnim
            target: notification
            property: "opacity"
            duration: PillController.activeFace === "notification" ? Config.animMs : Config.animMsClose
            easing.type: PillController.activeFace === "notification" ? Easing[Config.animEasingOut] : Easing[Config.animEasingIn]
        }
        NumberAnimation {
            id: gamebarOpAnim
            target: gamebar
            property: "opacity"
            duration: PillController.activeFace === "gamebar" ? Config.animMs : Config.animMsClose
            easing.type: PillController.activeFace === "gamebar" ? Easing[Config.animEasingOut] : Easing[Config.animEasingIn]
        }
        NumberAnimation {
            id: agentOpAnim
            target: agent
            property: "opacity"
            duration: PillController.activeFace === "agent" ? Config.animMs : Config.animMsClose
            easing.type: PillController.activeFace === "agent" ? Easing[Config.animEasingOut] : Easing[Config.animEasingIn]
        }
    }

    HoverHandler {
        id: hover
        onHoveredChanged: {
            PillController.pinned = hovered;
        }
    }

    RectangularShadow {
        id: shadow
        anchors.fill: rect
        blur: 30
        visible: !Gamemode.active
        offset: Qt.vector2d(0, 2)
        spread: 5
        color: Colors.md3.shadow
        radius: rect.radius
        opacity: 0.7
    }

    Clock {
        id: clock
        z: morphPill.panelTravel ? 2 : 1
        chrome: false
        opacity: morphPill.panelTravel ? 1 : morphPill.restOpacity
        visible: opacity > 0 && !morphPill.gamebarOnly && !morphPill.agentOnly
        enabled: visible

        readonly property real slotX: restContent.x + dynamicContent.x + clockSlot.x
        readonly property real slotY: restContent.y + dynamicContent.y + clockSlot.y
        readonly property real openY: Config.controlPanelPadding + (Config.controlPanelHeaderHeight - height) / 2
        x: {
            const open = (morphPill.width - width) / 2;
            return morphPill.panelTravel ? slotX + (open - slotX) * morphPill.grow : slotX;
        }
        y: morphPill.panelTravel ? slotY + (openY - slotY) * morphPill.grow : slotY
    }

    Rectangle {
        id: rect
        implicitWidth: parent.implicitWidth
        implicitHeight: parent.implicitHeight
        anchors.centerIn: parent
        //color: Gamemode.active ? Colors.md3.surface :Qt.alpha(Colors.md3.surface, 0.6)
        color: Colors.md3.surface
        border.width: Gamemode.active || ColorScheme.colorScheme === "oled" ? Config.borderWidth : 0
        radius: Gamemode.active ? 0 : Math.min(height / 2, morphPill.restHeight / 2 + Config.shellPadV)
        border.color: Gamemode.active || ColorScheme.colorScheme === "oled" ? Colors.md3.outline_variant : "transparent"

        Behavior on radius {
            enabled: !Gamemode.active && !morphPill.agentOnly && !morphPill.gamebarOnly
            NumberAnimation {
                duration: Config.animMs
                easing.type: Easing[Config.animEasing]
            }
        }

        TapHandler {
            id: tap
            onTapped: {
                enabled: morphPill.ready;
                if (doNotDisturbHover.hovered || PillController.overlay !== "none")
                    return;
                PillController.showPanel();
            }
        }
    }

    Row {
        id: restContent
        enabled: PillController.overlay === "none"
        opacity: morphPill.panelTravel ? 0 : morphPill.restOpacity
        visible: true
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: Config.spaceSm
        layer.enabled: restContent.opacity > 0 && restContent.opacity < 1

        Behavior on opacity {
            enabled: morphPill.fadeContent && Config.animMs > 0
            NumberAnimation {
                duration: Config.animMs
                easing.type: morphPill.panelTravel ? Easing[Config.animEasingIn] : Easing[Config.animEasingOut]
            }
        }

        y: {
            const shellH = morphPill.panelTravel ? morphPill.restH + morphPill.hoverGrow * (1 - morphPill.morph) : morphPill.height;
            return (shellH - height) / 2;
        }

    Item {
    id: batterySlot
    width: pinnedBatteries.shown ? pinnedBatteries.implicitWidth : 0
    height: pinnedBatteries.implicitHeight
    anchors.verticalCenter: parent.verticalCenter
    clip: width < pinnedBatteries.implicitWidth
    visible: width > 0 || opacity > 0
    opacity: width > 0 ? 1 : 0

    Behavior on width {
        enabled: morphPill.ready && morphPill.morph === 0 && Config.animMs > 0
        NumberAnimation {
            duration: Config.animMsClose
            easing.type: Easing[Config.animEasingIn]
        }
    }

    Behavior on opacity {
        enabled: morphPill.ready && morphPill.morph === 0 && Config.animMs > 0
        NumberAnimation {
            duration: Config.animMsClose
            easing.type: Easing[Config.animEasingIn]
        }
    }

    PinnedBatteries {
        id: pinnedBatteries
        readonly property bool shown: Power.shownDevices.length > 0
        visible: shown || opacity > 0
        opacity: shown ? 1 : 0
    }
}

        Item {
            id: mediaSlot
            property bool shown: (width > 0 || mediaChip.opacity > 0) && !morphPill.pillLock
            // The row gap and the chip's own right padding sit outside the
            // waveform. Fold both into the clock so the bars sit as close
            // to the time as the notification count does on the other side.
            readonly property real clockGap: Config.spaceSm + mediaChip.padH
            width: mediaChip.shown ? Math.max(0, mediaChip.implicitWidth - clockGap) : 0
            height: mediaChip.implicitHeight
            clip: width < mediaChip.implicitWidth - clockGap
            visible: shown || opacity > 0
            opacity: shown ? 1 : 0

            Behavior on width {
                enabled: morphPill.ready && morphPill.morph === 0 && Config.animMs > 0
                NumberAnimation {
                    duration: mediaSlot.shown ? Config.animMsClose : Config.animMs
                    easing.type: mediaSlot.shown ? Easing[Config.animEasingIn] : Easing[Config.animEasingOut]
                }
            }

            Behavior on opacity {
                enabled: morphPill.ready && morphPill.morph === 0 && Config.animMs > 0
                NumberAnimation {
                    duration: mediaSlot.shown ? Config.animMs : Config.animMsClose
                    easing.type: mediaSlot.shown ? Easing[Config.animEasingOut] : Easing[Config.animEasingIn]
                }
            }


            MediaChip {
                id: mediaChip
                readonly property bool shown: Media.active && !Media.isIdle && (!morphPill.gamebarOnly && !morphPill.agentOnly) && !PillController.pillLock
                visible: shown || opacity > 0
                opacity: shown ? 1 : 0
                chrome: false
                padH: Config.pillPadH / 2
                y: Config.pillPadV - 2
                Behavior on opacity {
                    NumberAnimation {
                        duration: mediaChip.shown ? Config.animMs : Config.animMsClose
                        easing.type: mediaChip.shown ? Easing[Config.animEasingOut] : Easing[Config.animEasingIn]
                    }
                }
            }
        }

        Row {
            id: dynamicContent
            spacing: 0
            anchors.verticalCenter: parent.verticalCenter

            Item {
                id: clockSlot
                width: !morphPill.gamebarOnly && !morphPill.agentOnly ? clock.implicitWidth : 0
                height: clock.implicitHeight
                anchors.verticalCenter: parent.verticalCenter
            }

            Item {
                id: doNotDisturbSlot
                property bool shown: Notifications.doNotDisturb && States.showDoNotDisturb && !gamebarOnly && !agentOnly && !PillController.pillLock
                width: shown ? doNotDisturbChip.implicitWidth + Config.spaceSm : 0
                height: doNotDisturbChip.implicitHeight
                anchors.verticalCenter: parent.verticalCenter
                clip: true
                visible: shown || opacity > 0
                opacity: shown ? 1 : 0

                Behavior on width {
                    enabled: morphPill.ready && morphPill.morph === 0 && Config.animMs > 0
                    NumberAnimation {
                        duration: Config.animMs
                        easing.type: Easing[Config.animEasingOut]
                    }
                }

                Behavior on opacity {
                    NumberAnimation {
                        duration: Config.animMs
                        easing.type: Easing[Config.animEasingOut]
                    }
                }

                DoNotDisturbChip {
                    id: doNotDisturbChip
                    anchors.verticalCenter: parent.verticalCenter
                    color: doNotDisturbHover.hovered ? Colors.md3.primary : Colors.md3.tertiary

                    HoverHandler {
                        id: doNotDisturbHover
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: Config.animMs
                            easing.type: Easing[Config.animEasingOut]
                        }
                    }
                }
            }

            Item {
                id: notificationChipSlot
                property bool shown: (Notifications.unreadCount > 0) && !Notifications.doNotDisturb && !gamebarOnly && !agentOnly && !PillController.pillLock
                width: notificationChip.shown ? notificationChip.implicitWidth + Config.spaceSm : 0
                height: notificationChip.implicitHeight
                anchors.verticalCenter: parent.verticalCenter
                clip: true
                visible: shown || opacity > 0
                opacity: shown ? 1 : 0

                Behavior on width {
                    enabled: morphPill.ready && morphPill.morph === 0 && Config.animMs > 0
                    NumberAnimation {
                        duration: Config.animMs
                        easing.type: Easing[Config.animEasingOut]
                    }
                }

                Behavior on opacity {
                    NumberAnimation {
                        duration: Config.animMs
                        easing.type: Easing[Config.animEasingOut]
                    }
                }

                NotificationChip {
                    id: notificationChip
                    property bool shown: (Notifications.unreadCount > 0) && !Notifications.doNotDisturb && !gamebarOnly && !agentOnly && !PillController.pillLock
                    anchors.verticalCenter: parent.verticalCenter
                    color: notificationChipHover.hovered ? Colors.md3.primary : (Notifications.unreadCount > 5 ? Colors.md3.error : Colors.md3.tertiary)

                    Behavior on color {
                        ColorAnimation {
                            duration: Config.animMs
                            easing.type: Easing[Config.animEasingOut]
                        }
                    }

                    Behavior on opacity {
                        NumberAnimation {
                            duration: Config.animMs
                            easing.type: Easing[Config.animEasingOut]
                        }
                    }
                    TapHandler {
                        id: notificationChipTap
                        onTapped: PillController.page = "notifications"
                    }

                    TapHandler {
                        id: notificationChipTapAlternate
                        onTapped: Notifications.clearAll()
                        acceptedButtons: Qt.RightButton
                    }

                    HoverHandler {
                        id: notificationChipHover
                    }
                }
            }

            Item {
                id: faceHost
                anchors.verticalCenter: parent.verticalCenter
                width: face ? morphPill.face.implicitWidth : 0
                height: face ? morphPill.face.implicitHeight : 0
                implicitWidth: width
                implicitHeight: height
                clip: true

                Behavior on width {
                    enabled: morphPill.ready && morphPill.morph === 0 && Config.animMs > 0
                    NumberAnimation {
                        duration: PillController.activeFace === PillController.defaultFace ? Config.animMsClose : Config.animMs
                        easing.type: PillController.activeFace === PillController.defaultFace ? Easing[Config.animEasingIn] : Easing[Config.animEasingOut]
                    }
                }
                Behavior on height {
                    enabled: morphPill.ready && morphPill.morph === 0 && Config.animMs > 0 && !morphPill.agentOnly
                    NumberAnimation {
                        duration: PillController.activeFace === PillController.defaultFace ? Config.animMsClose : Config.animMs
                        easing.type: PillController.activeFace === PillController.defaultFace ? Easing[Config.animEasingIn] : Easing[Config.animEasingOut]
                    }
                }

                Workspaces {
                    id: workspaces
                    readonly property bool faceActive: PillController.activeFace === "workspaces" && !PillController.pillLock
                    enabled: faceActive && restContent.enabled
                    visible: faceActive || opacity > 0
                    opacity: 0
                    anchors.top: parent.top
                    chrome: false
                    padH: 0
                    animateWidths: faceActive && morphPill.morph === 0
                }

                Volume {
                    id: volume
                    readonly property bool faceActive: PillController.activeFace === "volume" && !PillController.pillLock
                    enabled: faceActive && restContent.enabled
                    visible: faceActive || opacity > 0
                    opacity: 0
                    anchors.top: parent.top
                    chrome: false
                    padH: 0
                }

                Notification {
                    id: notification
                    readonly property bool faceActive: PillController.activeFace === "notification" && !PillController.pillLock
                    enabled: faceActive && restContent.enabled
                    visible: faceActive || opacity > 0
                    opacity: 0
                    anchors.top: parent.top
                    chrome: false
                    padH: 0
                }

                GameBar {
                    id: gamebar
                    readonly property bool faceActive: PillController.activeFace === "gamebar" && !PillController.pillLock
                    enabled: faceActive && restContent.enabled
                    visible: faceActive || opacity > 0
                    opacity: 0
                    chrome: false
                }

                Agent {
                    id: agent
                    readonly property bool faceActive: PillController.activeFace === "agent" && !PillController.pillLock
                    enabled: faceActive && restContent.enabled
                    visible: faceActive || opacity > 0
                    opacity: 0
                    chrome: false
                }
            }
        }

        Idle {
            id: idle
            property bool shown: IdleInhibitor.inhibitIdle && !morphPill.gamebarOnly && !quickToggles.expanded && !PillController.pillLock
            anchors.verticalCenter: parent.verticalCenter
            width: implicitWidth
            clip: true
            visible: shown || opacity > 0
            opacity: shown ? 1 : 0
        }

        Item {
            id: quickTogglesSlot
            property real reveal: PillController.pillLock || morphPill.gamebarOnly || morphPill.agentOnly ? 0 : 1
            width: quickToggles.implicitWidth * reveal
            height: quickToggles.implicitHeight
            anchors.verticalCenter: parent.verticalCenter
            clip: true
            //visible: width > 0 || reveal > 0
            visible: false

            Behavior on reveal {
                NumberAnimation {
                    duration: Config.animMsClose
                    easing.type: Easing[Config.animEasingIn]
                }
            }

            QuickToggles {
                id: quickToggles
                anchors.verticalCenter: parent.verticalCenter
                barHovered: hover.hovered
            }
        }
    }

    OverlayLayer {
        name: "panel"
        morph: morphPill.morph
        contentOpacity: morphPill.panelOpacity
        width: Config.controlPanelW - Config.controlPanelPadding * 2
        anchors.top: parent.top
        anchors.topMargin: Config.controlPanelPadding
        anchors.horizontalCenter: parent.horizontalCenter

        ControlPanel {
            id: panel
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    OverlayLayer {
        name: "launcher"
        morph: morphPill.morph
        contentOpacity: morphPill.panelOpacity
        anchors.fill: parent
        anchors.margins: Config.controlPanelPadding

        Launcher {
            anchors.fill: parent
        }
    }

    OverlayLayer {
        name: "bluetooth"
        morph: morphPill.morph
        contentOpacity: morphPill.panelOpacity
        anchors.fill: parent
        anchors.margins: Config.controlPanelPadding

        BluetoothMenu {
            anchors.fill: parent
        }
    }

    OverlayLayer {
        name: "wifi"
        morph: morphPill.morph
        contentOpacity: morphPill.panelOpacity
        anchors.fill: parent
        anchors.margins: Config.controlPanelPadding

        WifiMenu {
            anchors.fill: parent
        }
    }

    OverlayLayer {
        name: "wallpaperSwitcher"
        morph: morphPill.morph
        contentOpacity: morphPill.panelOpacity
        anchors.fill: parent
        anchors.margins: Config.controlPanelPadding

        WallpaperSwitcher {
            anchors.fill: parent
        }
    }

    VolumeBehavior {}
    WorkspacesBehavior {}
    NotificationBehavior {}
    GameBarBehavior {}
    AgentBehavior {}
}
