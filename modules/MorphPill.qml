import QtQuick
import qs.modules.bar
import qs.services
import qs.modules.behaviors
import qs.theme
import qs.config
import qs.modules.panel

Item {
    id: morphPill

    readonly property real restHeight: clock.implicitHeight
    readonly property bool ready: restW > 0 && restH > 0

    property bool latchedHighlight: false

    readonly property Item face: {
        switch (PillController.activeFace) {
        case "workspaces":
            return workspaces;
        case "volume":
            return volume;
        case "notification":
            return notification;
        default:
            return clock;
        }
    }

    property real morph: PillController.panelOpen ? 1 : 0

    Behavior on morph {
        enabled: morphPill.ready && Config.animMs > 0
        NumberAnimation {
            duration: Config.animMs
            easing.type: Easing.InOutCubic
        }
    }

    property real restW: 0
    property real restH: 0
    property real hostW: 0
    property real hostH: 0

    readonly property real liveRestW: restContent.implicitWidth * Config.pillFaceWidthScale
    readonly property real liveRestH: restContent.implicitHeight

    onLiveRestWChanged: if (morph === 0)
        restW = liveRestW

    onLiveRestHChanged: if (morph === 0)
        restH = liveRestH

    onMorphChanged: if (morph === 0) {
        restW = liveRestW;
        restH = liveRestH;
    }

    function snapHostToFace() {
        hostW = face.implicitWidth;
        hostH = face.implicitHeight;
        clock.opacity = PillController.activeFace === "clock" ? 1 : 0;
        workspaces.opacity = PillController.activeFace === "workspaces" ? 1 : 0;
        volume.opacity = PillController.activeFace === "volume" ? 1 : 0;
        notification.opacity = PillController.activeFace === "notification" ? 1 : 0;
    }

    function runFaceAnim() {
        if (!ready || morph !== 0 || Config.animMs <= 0) {
            snapHostToFace();
            return;
        }
        faceAnim.stop();
        hostWAnim.to = face.implicitWidth;
        hostHAnim.to = face.implicitHeight;
        clockOpAnim.to = PillController.activeFace === "clock" ? 1 : 0;
        wsOpAnim.to = PillController.activeFace === "workspaces" ? 1 : 0;
        volumeOpAnim.to = PillController.activeFace === "volume" ? 1 : 0;
        notifOpAnim.to = PillController.activeFace === "notification" ? 1 : 0;
        faceAnim.start();
    }

    width: restW + (Config.controlPanelW - restW) * morph
    height: restH + (Config.controlPanelH - restH) * morph
    implicitWidth: width
    implicitHeight: height

    clip: false

    readonly property bool shellBusy: morph > 0 && morph < 1

    onShellBusyChanged: {
        if (shellBusy)
            latchedHighlight = PillController.panelOpen || hover.hovered;
    }

    readonly property real restOpacity: morph <= 0 ? 1 : morph >= 0.35 ? 0 : 1 - morph / 0.35
    readonly property real panelOpacity: morph <= 0.4 ? 0 : Math.min((morph - 0.4) / 0.6, 1)

    Component.onCompleted: {
        snapHostToFace();
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
            id: hostWAnim
            target: morphPill
            property: "hostW"
            duration: Config.animMs
            easing.type: Easing.InOutCubic
        }
        NumberAnimation {
            id: hostHAnim
            target: morphPill
            property: "hostH"
            duration: Config.animMs
            easing.type: Easing.InOutCubic
        }
        NumberAnimation {
            id: clockOpAnim
            target: clock
            property: "opacity"
            duration: Config.animMs
            easing.type: Easing.InOutCubic
        }
        NumberAnimation {
            id: wsOpAnim
            target: workspaces
            property: "opacity"
            duration: Config.animMs
            easing.type: Easing.InOutCubic
        }
        NumberAnimation {
            id: volumeOpAnim
            target: volume
            property: "opacity"
            duration: Config.animMs
            easing.type: Easing.InOutCubic
        }
        NumberAnimation {
            id: notifOpAnim
            target: notification
            property: "opacity"
            duration: Config.animMs
            easing.type: Easing.InOutCubic
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
        radius: Config.radiusPill
        border.color: (morphPill.shellBusy ? morphPill.latchedHighlight : (PillController.panelOpen || hover.hovered)) ? Colors.md3.primary : Colors.md3.shadow

        Behavior on border.color {
            enabled: !morphPill.shellBusy
            ColorAnimation {
                duration: Config.animMs
                easing.type: Easing.InOutCubic
            }
        }

        TapHandler {
            id: tap
            onTapped: {
                enabled: morphPill.ready
                PillController.togglePanel()
            }
        }
    }

    Row {
        id: restContent
        enabled: morphPill.morph === 0
        opacity: morphPill.restOpacity
        visible: true
        anchors.centerIn: parent
        spacing: Config.spaceSm
        layer.enabled: restContent.opacity > 0 && restContent.opacity < 1

        MediaChip {
            visible: Media.active
            chrome: false
            anchors.verticalCenter: parent.verticalCenter
        }

        Item {
            id: faceHost
            width: morphPill.face.implicitWidth
            height: morphPill.face.implicitHeight
            implicitWidth: width
            implicitHeight: height
            clip: false

            Behavior on width {
                enabled: morphPill.ready && morphPill.morph === 0  && Config.animMs > 0
                NumberAnimation {
                    duration: Config.animMs
                    easing.type: Easing.InOutCubic
                }
            }
            Behavior on height {
                enabled: morphPill.ready && morphPill.morph === 0  && Config.animMs > 0
                NumberAnimation {
                    duration: Config.animMs
                    easing.type: Easing.InOutCubic
                }
            }

            Clock {
                id: clock
                readonly property bool faceActive: PillController.activeFace === "clock"
                enabled: faceActive && restContent.enabled
                anchors.centerIn: parent
                chrome: false
            }

            Workspaces {
                id: workspaces
                readonly property bool faceActive: PillController.activeFace === "workspaces"
                enabled: faceActive && restContent.enabled
                anchors.centerIn: parent
                chrome: false
                animateWidths: faceActive && morphPill.morph === 0
            }

            Volume {
                id: volume
                readonly property bool faceActive: PillController.activeFace === "volume"
                enabled: faceActive && restContent.enabled
                anchors.centerIn: parent
                chrome: false
            }

            Notification {
                id: notification
                readonly property bool faceActive: PillController.activeFace === "notification"
                enabled: faceActive && restContent.enabled
                anchors.centerIn: parent
                chrome: false
            }
        }

        Idle {
            id: idle
            anchors.verticalCenter: parent.verticalCenter
            visible: IdleInhibitor.inhibitIdle
        }
    }

    ControlPanel {
        id: panel
        anchors.top: parent.top
        anchors.topMargin: Config.controlPanelPadding
        anchors.horizontalCenter: parent.horizontalCenter
        z: 1
        opacity: morphPill.panelOpacity
        enabled: morphPill.morph >= 0.85
    }

    VolumeBehavior {}
    WorkspacesBehavior {}
    NotificationBehavior {}
}
