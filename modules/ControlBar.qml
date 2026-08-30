import Quickshell
import Quickshell.Io
import QtQuick
import Quickshell.Wayland
import qs.config
import qs.services
import qs.theme

Variants {
    model: Quickshell.screens
    PanelWindow {
        id: bar
        WlrLayershell.namespace: "quickshell:bar"
        WlrLayershell.layer: WlrLayer.Top
        required property var modelData
        screen: modelData
        property alias barVisible: bar.visible

        exclusionMode: ExclusionMode.Normal
        exclusiveZone: morphPill.restHeight + Config.barMarginV
        color: "transparent"
        implicitHeight: modelData.height

        anchors {
            top: true
            left: true
            right: true
        }

        mask: Region {
            item: PillController.panelOpen ? background : morphPill
        }

        Rectangle {
            id: background
            anchors.fill: parent
            color: Colors.md3.surface
            opacity: PillController.panelOpen ? 0.5 : 0
            z: -1


            MouseArea {
                anchors.fill: parent
                enabled: PillController.panelOpen
                onClicked: PillController.panelOpen = false
            }
        }

        MorphPill {
            id: morphPill
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: Config.barMarginV
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
