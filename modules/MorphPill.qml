import QtQuick
import qs.modules.bar
import qs.services

Item {
    id: morphPill

    readonly property Item face: {
        switch (MorphPillHandler.activeFace) {
            case "workspaces": return workspaces
            case "clock":
            default: return clock
        }
    }
    implicitHeight: face.implicitHeight
    implicitWidth: face.implicitWidth

    Clock {
        id: clock

        visible: MorphPillHandler.activeFace === "clock"
    }

    Workspaces {
        id: workspaces

        visible: MorphPillHandler.activeFace === "workspaces"
    }

}
