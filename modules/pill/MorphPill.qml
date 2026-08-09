import QtQuick
import qs.modules.elements
import qs.services
import qs.modules.pill
import qs.config

PillShape {
    id: root
    clip: true
    focus: true

    property var faces: ({
            "clock": clock,
            "volume": volume,
            "workspaces": workspaces
        })

    readonly property Item activeItem: root.faces[PillController.activeFace] ?? clock

    width: (activeItem ? activeItem.implicitWidth : 0) + padH * 2
    height: (activeItem ? activeItem.implicitHeight : 0) + padV * 2


    Item {
        id: faceHost
        implicitWidth: root.activeItem.implicitWidth
        implicitHeight: root.activeItem.implicitHeight
        width: implicitWidth
        height: implicitHeight

        component FaceLayer: Item {
            id: layer
            required property string name
            default property alias content: stack.data

            implicitWidth: stack.children[0]?.implicitWidth ?? 0
            implicitHeight: stack.children[0]?.implicitHeight ?? 0

            opacity: PillController.activeFace === name ? 1 : 0
            enabled: PillController.activeFace === name

            Behavior on opacity {
                NumberAnimation {
                    duration: Config.animMs
                    easing.type: Easing.OutCubic
                }
            }

            Item {
                id: stack
                anchors.fill: parent
            }
        }

        FaceLayer {
            id: clock
            name: "clock"
            anchors.centerIn: parent
            ClockFace {}
        }

        FaceLayer {
            id: volume
            name: "volume"
            anchors.centerIn: parent
            VolumeFace {}
        }

        FaceLayer {
            id: workspaces
            name: "workspaces"
            anchors.centerIn: parent
            WorkspaceFace {}
        }
    }

    Behavior on width {
        NumberAnimation {
            duration: Config.animMs
            easing.type: Easing.OutCubic
        }
    }
    Behavior on height {
        NumberAnimation {
            duration: Config.animMs
            easing.type: Easing.OutCubic
        }
    }
}
