import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Effects
import Quickshell.Wayland
import qs.config
import qs.services
import qs.theme

Variants {
    id: bars
    property bool lockHeld: PillController.lockHeld
    property real pillWidth: 0
    property real pillHeight: 0
    property real clockShift: 0
    model: Quickshell.screens
    PanelWindow {
        id: bar
        WlrLayershell.namespace: "quickshell:bar"
        WlrLayershell.layer: WlrLayer.Top
        WlrLayershell.keyboardFocus: PillController.overlay !== "none" ? WlrKeyboardFocus.Exclusive : PillController.activeFace === "agent" ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
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
            //opacity: 0
            z: -1

            Item {
                anchors.fill: parent
                focus: true
                Keys.onEscapePressed: PillController.closeOverlay()
            }

            MouseArea {
                anchors.fill: parent
                enabled: PillController.overlay !== "none"
                onClicked: PillController.closeOverlay()
            }
        }

        MorphPill {
            id: morphPill
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: Config.barMarginV
            visible: Config.showClock
            opacity: bars.lockHeld ? 0 : 1
            z: 1
        }

        Binding {
            target: bars
            property: "pillWidth"
            value: morphPill.restW
        }
        Binding {
            target: bars
            property: "pillHeight"
            value: morphPill.restH
        }
        Binding {
            target: bars
            property: "clockShift"
            value: morphPill.clockShift
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
