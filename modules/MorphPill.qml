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

    readonly property Item face: {
        switch (PillController.activeFace) {
        case "workspaces":
            return workspaces;
        case "volume":
            return volume;
        case "notification":
            return notification;
        case "clock":
        default:
            return clock;
        }
    }

    function faceFor(name) {
        switch (name) {
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

    function sizeFor(name) {
        const f = faceFor(name);
        return Qt.size(f.implicitWidth, f.implicitHeight);
    }

    property real shellW: 0
    property real shellH: 0
    property bool ready: false
    property bool expanded: false

    readonly property real targetW: PillController.panelOpen ? Config.controlPanelW : restContent.implicitWidth * Config.pillFaceWidthScale
    readonly property real targetH: PillController.panelOpen ? Config.controlPanelH : restContent.implicitHeight

    width: Math.round(shellW)
    height: Math.round(shellH)
    implicitWidth: width
    implicitHeight: height

    Behavior on shellW {
        enabled: morphPill.ready
        NumberAnimation {
            duration: Config.animMs
            easing.type: Easing.InOutCubic
        }
    }

    NumberAnimation {
        id: heightAnim
        target: morphPill
        property: "shellH"
        duration: Config.animMs
        easing.type: Easing.InOutCubic
    }

    onTargetWChanged: shellW = targetW
    onTargetHChanged: {
        if (!morphPill.ready) {
            shellH = targetH;
            return;
        }
        heightAnim.stop();
        heightAnim.to = targetH;
        heightAnim.start();
    }

    Component.onCompleted: {
        shellW = targetW;
        shellH = targetH;
        ready = true;
    }

    HoverHandler {
        onHoveredChanged: {
            PillController.pinned = hovered;
        }
    }

    readonly property bool shellBusy: heightAnim.running || Math.abs(shellW - targetW) > 0.5

    property bool latchedHighlight: false

    onShellBusyChanged: {
        if (shellBusy)
            latchedHighlight = PillController.panelOpen || mouse.containsMouse;
    }
    Rectangle {
        id: rect
        anchors.fill: parent
        color: Colors.md3.surface
        border.width: Config.borderWidth
        radius: Config.radiusPill
        border.color: (parent.shellBusy ? parent.latchedHighlight : (PillController.panelOpen || mouse.containsMouse)) ? Colors.md3.primary : Colors.md3.shadow
        Behavior on border.color {
            enabled: !morphPill.shellBusy
            ColorAnimation {
                duration: Config.animMs
                easing.type: Easing.InOutCubic
            }
        }
    }

    Row {
        id: restContent
        enabled: !PillController.panelOpen
        opacity: PillController.panelOpen ? 0 : 1
        visible: opacity > 0
        anchors.centerIn: parent
        spacing: Config.spaceSm
        layer.enabled: opacity > 0 && opacity < 1

        Behavior on opacity {
            NumberAnimation {
                duration: Config.animMs
                easing.type: Easing.InOutCubic
            }
        }

        MediaChip {
            visible: Media.active
            chrome: false
            anchors.verticalCenter: parent.verticalCenter
        }

        Item {
            id: faceHost
            width: morphPill.face.implicitWidth
            height: morphPill.face.implicitHeight
            clip: true

            Clock {
                id: clock
                enabled: PillController.activeFace === "clock"
                opacity: enabled ? 1 : 0
                anchors.centerIn: parent
                chrome: false
                Behavior on opacity {
                    NumberAnimation {
                        duration: Config.animMs
                        easing.type: Easing.InOutCubic
                    }
                }
            }

            Workspaces {
                id: workspaces
                enabled: PillController.activeFace === "workspaces"
                opacity: enabled ? 1 : 0
                anchors.centerIn: parent
                chrome: false
                animateWidths: PillController.activeFace === "workspaces"
                Behavior on opacity {
                    NumberAnimation {
                        duration: Config.animMs
                        easing.type: Easing.InOutCubic
                    }
                }
            }

            Volume {
                id: volume
                enabled: PillController.activeFace === "volume"
                opacity: enabled ? 1 : 0
                anchors.centerIn: parent
                chrome: false
                Behavior on opacity {
                    NumberAnimation {
                        duration: Config.animMs
                        easing.type: Easing.InOutCubic
                    }
                }
            }

            Notification {
                id: notification
                enabled: PillController.activeFace === "notification"
                opacity: enabled ? 1 : 0
                anchors.centerIn: parent
                chrome: false
                Behavior on opacity {
                    NumberAnimation {
                        duration: Config.animMs
                        easing.type: Easing.InOutCubic
                    }
                }
            }
        }
    }

    ControlPanel {
        z: 1
    }

    VolumeBehavior {}
    WorkspacesBehavior {}
    NotificationBehavior {}

    MouseArea {
        id: mouse
        anchors.fill: parent
        z: -1
        hoverEnabled: true
        onClicked: {
            PillController.togglePanel();
        }
    }
}
