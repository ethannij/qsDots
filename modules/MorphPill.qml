import QtQuick
import qs.modules.bar
import qs.services
import qs.modules.behaviors
import qs.config
import qs.theme


Item {
    id: morphPill

    clip: true
    width: face.implicitWidth
    height: face.implicitHeight

    readonly property Item face: {
        switch (PillController.activeFace) {
            case "workspaces": return workspaces
            case "volume": return volume
            case "notification": return notification
            case "clock":
            default: return clock
        }
    }
    implicitHeight: face.implicitHeight
    implicitWidth: face.implicitWidth

   Behavior on implicitHeight {
        NumberAnimation {
            duration: Config.animMs
            easing.type: Easing.InOutExpo
        }
    }

    Behavior on implicitWidth {
        NumberAnimation {
            duration: Config.animMs
            easing.type: Easing.InOutExpo
        }
    }


    Rectangle {
        anchors.fill: parent
        color: Colors.md3.surface
        border.width: Config.borderWidth
        border.color: Colors.md3.shadow
        radius: Config.radiusPill
    }


    Clock {
        id: clock

        opacity: PillController.activeFace === "clock" ? 1 : 0
        visible: opacity > 0
        anchors.centerIn: parent
        chrome: false
        Behavior on opacity {
            NumberAnimation {
                duration: Config.animMs
                easing.type: Easing.InOutExpo
            }
        }
    }

    Workspaces {
        id: workspaces

        opacity: PillController.activeFace === "workspaces" ? 1 : 0
        visible: opacity > 0
        anchors.centerIn: parent
        chrome: false
        Behavior on opacity {
            NumberAnimation {
                duration: Config.animMs
                easing.type: Easing.InOutExpo
            }
        }
    }

    Volume {
        id: volume

        opacity: PillController.activeFace === "volume" ? 1 : 0
        visible: opacity > 0
        anchors.centerIn: parent
        Behavior on opacity {
            NumberAnimation {
                duration: Config.animMs
                easing.type: Easing.InOutExpo
            }
        }
    }

    Notification {
        id: notification

        opacity: PillController.activeFace === "notification" ? 1 : 0
        visible: opacity > 0
        anchors.centerIn: parent
        chrome: false
        Behavior on opacity {
            NumberAnimation {
                duration: Config.animMs
                easing.type: Easing.InOutExpo
            }
        }
    }

    VolumeBehavior {}
    WorkspacesBehavior {}
    NotificationBehavior {}


}
