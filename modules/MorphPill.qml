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
        case "controlpanel": return controlpanel;
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
        case "controlpanel": return controlpanel;
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


    readonly property real targetW: face.implicitWidth * 1.5
    readonly property real targetH: face.implicitHeight

    width: shellW
    height: shellH
    implicitWidth: shellW
    implicitHeight: shellH
    property real expandedW: shellW * 1.3
    property real expandedH: shellH * 1.5

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
        const s = sizeFor(PillController.activeFace);
        shellW = s.width;
        shellH = s.height;
        ready = true;
    }

    HoverHandler {
        onHoveredChanged: {
            PillController.pinned = hovered
            morphPill.expanded = true
        }

    }

    Rectangle {
        id: rect
        anchors.fill: parent
        color: Colors.md3.surface
        border.color: mouse.containsMouse ? Colors.md3.primary : Colors.md3.shadow
        radius: Config.radiusPill
        border.width: Config.borderWidth

        Behavior on border.color {
            ColorAnimation {
                duration: Config.animMs
                easing.type: Easing.InOutCubic
            }
        }
    }

    Clock {
        id: clock
        enabled: PillController.activeFace === "clock"

        opacity: PillController.activeFace === "clock" ? 1 : 0
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
        opacity: PillController.activeFace === "workspaces" ? 1 : 0
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
        opacity: PillController.activeFace === "volume" ? 1 : 0
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
        opacity: PillController.activeFace === "notification" ? 1 : 0
        anchors.centerIn: parent
        chrome: false
        Behavior on opacity {
            NumberAnimation {
                duration: Config.animMs
                easing.type: Easing.InOutCubic
            }
        }
    }

    ControlPanel {
        id: controlpanel
        enabled: PillController.activeFace === "controlpanel"
        opacity: PillController.activeFace === "controlpanel" ? 1 : 0
        anchors.centerIn: parent
        chrome: false
        Behavior on opacity {
            NumberAnimation {
                duration: Config.animMs
                easing.type: Easing.InOutCubic
            }
        }
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
            PillController.showFace("controlpanel")
        }

    }
}
