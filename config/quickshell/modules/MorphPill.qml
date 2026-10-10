import QtQuick
import qs.modules.bar
import qs.services
import qs.modules.behaviors
import qs.theme
import qs.config
import qs.modules.elements
import qs.modules.panel
import qs.modules.launcher
import qs.modules.windows

Item {
    id: morphPill

    readonly property real restHeight: clock.implicitHeight
    readonly property bool ready: restW > 0 && restH > 0

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
        default:
            return null;
        }
    }

    property real morph: PillController.overlay !== "none" ? 1 : 0

    Behavior on morph {
        enabled: morphPill.ready && Config.animMs > 0
        NumberAnimation {
            duration: PillController.overlay !== "none" ? Config.animMs : Config.animMsClose
            easing.type: PillController.overlay !== "none" ? Easing.OutCubic : Easing.InCubic
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

    function snapHostOpacity() {
        workspaces.opacity = PillController.activeFace === "workspaces" ? 1 : 0;
        volume.opacity = PillController.activeFace === "volume" ? 1 : 0;
        notification.opacity = PillController.activeFace === "notification" ? 1 : 0;
        gamebar.opacity = PillController.activeFace === "gamebar" ? 1 : 0;
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
        faceAnim.start();
    }

    width: restW + (Config.controlPanelW - restW) * morph
    height: restH + (Config.controlPanelH - restH) * morph
    implicitWidth: width
    implicitHeight: height

    clip: false

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
    }

    HoverHandler {
        id: hover
        onHoveredChanged: {
            PillController.pinned = hovered;
        }
    }

    Rectangle {
        id: rect
        anchors.fill: parent
        color: Colors.md3.surface
        border.width: Config.borderWidth
        radius: Gamemode.active ? 0 : Math.min(height / 2, morphPill.restHeight / 2 + Config.shellPadV)
        border.color: Colors.md3.outline_variant

        Behavior on radius {
            enabled: !Gamemode.active
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

        MediaChip {
            visible: Media.active
            chrome: false
            anchors.top: parent.top
        }

        Row {
            id: dynamicContent
            spacing: 0
            anchors.top: parent.top

            Clock {
                id: clock
                enabled: restContent.enabled
                visible: true
                opacity: 1
                anchors.top: parent.top
                chrome: false
            }

            Item {
                id: faceHost
                width: face ? morphPill.face.implicitWidth + Config.spaceSm: 0
                height: face ? morphPill.face.implicitHeight : 0
                implicitWidth: width
                implicitHeight: height
                anchors.top: parent.top
                clip: true

                Behavior on width {
                    enabled: morphPill.ready && morphPill.morph === 0 && Config.animMs > 0
                    NumberAnimation {
                        duration: PillController.activeFace === PillController.defaultFace ? Config.animMsClose : Config.animMs
                        easing.type: PillController.activeFace === PillController.defaultFace ? Easing.InCubic : Easing.OutCubic
                    }
                }
                Behavior on height {
                    enabled: morphPill.ready && morphPill.morph === 0 && Config.animMs > 0
                    NumberAnimation {
                        duration: PillController.activeFace === PillController.defaultFace ? Config.animMsClose : Config.animMs
                        easing.type: PillController.activeFace === PillController.defaultFace ? Easing.InCubic : Easing.OutCubic
                    }
                }

                Workspaces {
                    id: workspaces
                    readonly property bool faceActive: PillController.activeFace === "workspaces"
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
                    readonly property bool faceActive: PillController.activeFace === "volume"
                    enabled: faceActive && restContent.enabled
                    visible: faceActive || opacity > 0
                    opacity: 0
                    x: Config.spaceSm
                    anchors.top: parent.top
                    chrome: false
                }

                Notification {
                    id: notification
                    readonly property bool faceActive: PillController.activeFace === "notification"
                    enabled: faceActive && restContent.enabled
                    visible: faceActive || opacity > 0
                    opacity: 0
                    x: Config.spaceSm
                    anchors.top: parent.top
                    chrome: false
                }

                GameBar {
                    id: gamebar
                    readonly property bool faceActive: PillController.activeFace === "gamebar"
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
            anchors.verticalCenter: parent.verticalCenter
            visible: IdleInhibitor.inhibitIdle
        }
    }

    OverlayLayer {
        name: "panel"
        morph: morphPill.morph
        contentOpacity: morphPill.panelOpacity
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
}
