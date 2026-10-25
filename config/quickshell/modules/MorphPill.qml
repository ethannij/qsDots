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
            easing.type: PillController.overlay !== "none" ? Easing.OutCubic : Easing.InCubic
        }
    }

    property real hoverGrow: !morphPill.pillLock ? (hover.hovered && morph === 0 ? 8 : 0) : 0

    Behavior on hoverGrow {
        enabled: morphPill.ready && Config.animMs > 0
        NumberAnimation {
            duration: Config.animMs
            easing.type: Easing.OutCubic
        }
    }

    property real restW: 0
    property real restH: 0

    readonly property real liveRestW: restContent.implicitWidth + Config.shellPadH * 2
    readonly property real liveRestH: restContent.implicitHeight + Config.shellPadV * 2

    onLiveRestWChanged: if (morph === 0)
        restW = liveRestW

    onLiveRestHChanged: if (morph === 0)
        restH = liveRestH

    onMorphChanged: if (morph === 0) {
        restW = liveRestW;
        restH = liveRestH;
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

    width: restW + hoverGrow * (1 - morph) + (Config.controlPanelW - restW) * morph
    height: restH + hoverGrow * (1 - morph) + (Config.controlPanelH - restH) * morph
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
    }

    ParallelAnimation {
        id: faceAnim

        NumberAnimation {
            id: mediaChipOpAnim
            target: mediaChip
            property: "opacity"
            duration: !Media.isIdle ? Config.animMs : Config.animMsClose
            easing.type: !Media.isIdle ? Easing.OutCubic : Easing.InCubic
        }

        NumberAnimation {
            id: wsOpAnim
            target: workspaces
            property: "opacity"
            duration: PillController.activeFace === "workspaces" ? Config.animMs : Config.animMsClose
            easing.type: PillController.activeFace === "workspaces" ? Easing.OutCubic : Easing.InCubic
        }
        NumberAnimation {
            id: volumeOpAnim
            target: volume
            property: "opacity"
            duration: PillController.activeFace === "volume" ? Config.animMs : Config.animMsClose
            easing.type: PillController.activeFace === "volume" ? Easing.OutCubic : Easing.InCubic
        }
        NumberAnimation {
            id: notifOpAnim
            target: notification
            property: "opacity"
            duration: PillController.activeFace === "notification" ? Config.animMs : Config.animMsClose
            easing.type: PillController.activeFace === "notification" ? Easing.OutCubic : Easing.InCubic
        }
        NumberAnimation {
            id: gamebarOpAnim
            target: gamebar
            property: "opacity"
            duration: PillController.activeFace === "gamebar" ? Config.animMs : Config.animMsClose
            easing.type: PillController.activeFace === "gamebar" ? Easing.OutCubic : Easing.InCubic
        }
        NumberAnimation {
            id: agentOpAnim
            target: agent
            property: "opacity"
            duration: PillController.activeFace === "agent" ? Config.animMs : Config.animMsClose
            easing.type: PillController.activeFace === "agent" ? Easing.OutCubic : Easing.InCubic
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

    Rectangle {
        id: rect
        implicitWidth: parent.implicitWidth
        implicitHeight: parent.implicitHeight
        anchors.centerIn: parent
        //color: Gamemode.active ? Colors.md3.surface :Qt.alpha(Colors.md3.surface, 0.6)
        color: Colors.md3.surface
        border.width: Gamemode.active || OLED.active ? Config.borderWidth : 0
        radius: Gamemode.active ? 0 : Math.min(height / 2, morphPill.restHeight / 2 + Config.shellPadV)
        border.color: Gamemode.active || OLED.active ? Colors.md3.outline_variant : "transparent"

        Behavior on radius {
            enabled: !Gamemode.active && !morphPill.agentOnly && !morphPill.gamebarOnly
            NumberAnimation {
                duration: Config.animMs
                easing.type: Easing.InOutCubic
            }
        }

        TapHandler {
            id: tap
            onTapped: {
                enabled: morphPill.ready;
                if (PillController.overlay !== "none")
                    return;
                PillController.showPanel();
            }
        }
    }

    Row {
        id: restContent
        enabled: PillController.overlay === "none"
        opacity: morphPill.restOpacity
        visible: true
        anchors.centerIn: parent
        spacing: Config.spaceSm
        layer.enabled: restContent.opacity > 0 && restContent.opacity < 1

        Item {
            id: mediaSlot
            property bool shown: (width > 0 || mediaChip.opacity > 0) && !morphPill.pillLock
            width: mediaChip.shown ? mediaChip.implicitWidth : 0
            height: mediaChip.implicitHeight
            clip: true
            visible: shown || opacity > 0
            opacity: shown ? 1 : 0

            Behavior on width {
                enabled: morphPill.ready && morphPill.morph === 0 && Config.animMs > 0
                NumberAnimation {
                    duration: shown ? Config.animMsClose : Config.animMs
                    easing.type: shown ? Easing.InCubic : Easing.OutCubic
                }
            }

            Behavior on opacity {
                enabled: morphPill.ready && morphPill.morph === 0 && Config.animMs > 0
                NumberAnimation {
                    duration: shown ? Config.animMs : Config.animMsClose
                    easing.type: shown ? Easing.OutCubic : Easing.InCubic
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
                        duration: shown ? Config.animMs : Config.animMsClose
                        easing.type: shown ? Easing.OutCubic : Easing.InCubic
                    }
                }
            }
        }

        Row {
            id: dynamicContent
            spacing: 0
            anchors.verticalCenter: parent.verticalCenter

            Clock {
                id: clock
                enabled: restContent.enabled
                visible: !morphPill.gamebarOnly && !morphPill.agentOnly
                opacity: 1
                chrome: false
            }

            Item {
                id: notificationChipSlot
                property bool shown: (Notifications.unreadCount > 0) && !Notifications.doNotDisturb && !gamebarOnly && !agentOnly && !PillController.pillLock
                width: notificationChip.shown ? notificationChip.implicitWidth : 0
                height: notificationChip.implicitHeight
                anchors.verticalCenter: parent.verticalCenter
                clip: true
                visible: shown || opacity > 0
                opacity: shown ? 1 : 0

                Behavior on width {
                    enabled: morphPill.ready && morphPill.morph === 0 && Config.animMs > 0
                    NumberAnimation {
                        duration: Config.animMs
                        easing.type: Easing.OutCubic
                    }
                }

                Behavior on opacity {
                    NumberAnimation {
                        duration: Config.animMs
                        easing.type: Easing.OutCubic
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
                            easing.type: Easing.OutCubic
                        }
                    }

                    Behavior on opacity {
                        NumberAnimation {
                            duration: Config.animMs
                            easing.type: Easing.OutCubic
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
                        cursorShape: Qt.PointingHandCursor
                    }
                }
            }

            Item {
                id: faceHost
                anchors.verticalCenter: parent.verticalCenter
                width: face ? morphPill.face.implicitWidth + Config.spaceSm : 0
                height: face ? morphPill.face.implicitHeight : 0
                implicitWidth: width
                implicitHeight: height
                clip: true

                Behavior on width {
                    enabled: morphPill.ready && morphPill.morph === 0 && Config.animMs > 0
                    NumberAnimation {
                        duration: PillController.activeFace === PillController.defaultFace ? Config.animMsClose : Config.animMs
                        easing.type: PillController.activeFace === PillController.defaultFace ? Easing.InCubic : Easing.OutCubic
                    }
                }
                Behavior on height {
                    enabled: morphPill.ready && morphPill.morph === 0 && Config.animMs > 0 && !morphPill.agentOnly
                    NumberAnimation {
                        duration: PillController.activeFace === PillController.defaultFace ? Config.animMsClose : Config.animMs
                        easing.type: PillController.activeFace === PillController.defaultFace ? Easing.InCubic : Easing.OutCubic
                    }
                }

                Workspaces {
                    id: workspaces
                    readonly property bool faceActive: PillController.activeFace === "workspaces" && !PillController.pillLock
                    enabled: faceActive && restContent.enabled
                    visible: faceActive || opacity > 0
                    opacity: 0
                    x: Config.spaceSm
                    anchors.top: parent.top
                    chrome: false
                    animateWidths: faceActive && morphPill.morph === 0
                }

                Volume {
                    id: volume
                    readonly property bool faceActive: PillController.activeFace === "volume" && !PillController.pillLock
                    enabled: faceActive && restContent.enabled
                    visible: faceActive || opacity > 0
                    opacity: 0
                    x: Config.spaceSm
                    anchors.top: parent.top
                    chrome: false
                }

                Notification {
                    id: notification
                    readonly property bool faceActive: PillController.activeFace === "notification" && !PillController.pillLock
                    enabled: faceActive && restContent.enabled
                    visible: faceActive || opacity > 0
                    opacity: 0
                    x: Config.spaceSm
                    anchors.top: parent.top
                    chrome: false
                }

                GameBar {
                    id: gamebar
                    readonly property bool faceActive: PillController.activeFace === "gamebar" && !PillController.pillLock
                    enabled: faceActive && restContent.enabled
                    visible: faceActive || opacity > 0
                    opacity: 0
                    x: Config.spaceSm
                    chrome: false
                }

                Agent {
                    id: agent
                    readonly property bool faceActive: PillController.activeFace === "agent" && !PillController.pillLock
                    enabled: faceActive && restContent.enabled
                    visible: faceActive || opacity > 0
                    opacity: 0
                    x: Config.spaceSm
                    chrome: false
                }
            }
        }

        Idle {
            id: idle
            property bool shown: IdleInhibitor.inhibitIdle && !morphPill.gamebarOnly && !quickToggles.expanded && !PillController.pillLock
            anchors.verticalCenter: parent.verticalCenter
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
            visible: width > 0 || reveal > 0 && shown

            Behavior on reveal {
                NumberAnimation {
                    duration: Config.animMsClose
                    easing.type: Easing.InCubic
                }
            }

            QuickToggles {
                id: quickToggles
                anchors.verticalCenter: parent.verticalCenter
                barHovered: hover.hovered
            }
        }

        Item {
            id: spacer
            width: Config.spaceSm
            height: 1
            visible: !morphPill.gamebarOnly && !morphPill.agentOnly && idle.visible
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
