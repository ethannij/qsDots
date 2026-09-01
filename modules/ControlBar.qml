import Quickshell
import Quickshell.Io
import QtQuick
import Quickshell.Wayland
import qs.config
import qs.services
import qs.theme
import qs.modules.launcher

Variants {
    model: Quickshell.screens
    PanelWindow {
        id: bar
        WlrLayershell.namespace: "quickshell:bar"
        WlrLayershell.layer: WlrLayer.Top
        WlrLayershell.keyboardFocus: PillController.overlay !== "none" ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
        required property var modelData
        screen: modelData
        property alias barVisible: bar.visible

        exclusionMode: ExclusionMode.Normal
        exclusiveZone: morphPill.restHeight + Config.barMarginV
        color: "transparent"
        implicitHeight: modelData.height

        Shortcut {
            enabled: PillController.overlay !== "none"
            sequence: "Escape"
            onActivated: PillController.closeOverlay()
        }

        anchors {
            top: true
            left: true
            right: true
        }

        mask: Region {
            item: PillController.overlay !== "none" ? background : morphPill
        }

        Rectangle {
            id: background
            anchors.fill: parent
            color: Colors.md3.surface
            opacity: PillController.overlay !== "none" ? 0.5 : 0
            z: -1

            Item {
                anchors.fill: parent
                focus: true
                Keys.onEscapePressed: {
                    if (PillController.overlay === "panel")
                        PillController.closePanel();
                    if (PillController.overlay === "launcher")
                        PillController.closeLauncher();
                }
            }

            MouseArea {
                anchors.fill: parent
                enabled: PillController.overlay !== "none"
                onClicked: {
                    if (PillController.overlay === "panel")
                        PillController.closePanel();
                    if (PillController.overlay === "launcher")
                        PillController.closeLauncher();
                }
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
