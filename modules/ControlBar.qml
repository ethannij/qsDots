import Quickshell
import Quickshell.Io
import QtQuick
import qs.config

Variants {
    model: Quickshell.screens
    PanelWindow {
        id: bar
        required property var modelData
        screen: modelData
        property alias barVisible: bar.visible

        exclusionMode: ExclusionMode.Normal
        exclusiveZone: morphPill.restHeight + Config.barMarginV
        color: "transparent"
        implicitHeight: morphPill.implicitHeight + Config.barVerticalPadding

        anchors {
            top: true
            left: true
            right: true
        }

        mask: Region {
            item: morphPill
        }

        MorphPill {
            id: morphPill
            anchors.centerIn: parent
            visible: Config.showClock
            z: 1
        }
        IpcHandler {
            id: ipcbar
            target: "ipcBar"
            function toggleBar(): void {
                bar.visible = !bar.visible;
            }
        }
    }
}
