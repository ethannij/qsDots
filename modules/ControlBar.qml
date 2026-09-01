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
        WlrLayershell.keyboardFocus: morphPill.overlay !== "none" ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
        required property var modelData
        screen: modelData
        property alias barVisible: bar.visible

        exclusionMode: ExclusionMode.Normal
        exclusiveZone: morphPill.restHeight + Config.barMarginV
        color: "transparent"
        implicitHeight: modelData.height

        Shortcut {
            enabled: morphPill.overlay !== "none"
            sequence: "Escape"
            onActivated: bar.closeOverlay()
        }

        anchors {
            top: true
            left: true
            right: true
        }

        mask: Region {
            item: morphPill.overlay !== "none" ? background : morphPill
        }

        function closeOverlay() {
            PillController.closePanel()
            PillController.closeLauncher()
            if (!PillController.panelOpen && !PillController.launcherOpen)
                morphPill.overlay = "none"
        }

        Rectangle {
            id: background
            anchors.fill: parent
            color: Colors.md3.surface
            opacity: morphPill.overlay !== "none" ? 0.5 : 0
            z: -1

            Item {
                anchors.fill: parent
                focus: true
                Keys.onEscapePressed: {
                    if (morphPill.overlay === "panel")
                        PillController.closePanel();
                    if (morphPill.overlay === "launcher")
                        PillController.closeLauncher();
                }
            }

            MouseArea {
                anchors.fill: parent
                enabled: morphPill.overlay !== "none"
                onClicked: {
                    if (morphPill.overlay === "panel")
                        PillController.closePanel();
                    if (morphPill.overlay === "launcher")
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
