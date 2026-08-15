import Quickshell
import Quickshell.Io
import QtQuick.Layouts
import QtQuick
import qs.config
import qs.modules.bar
import qs.services

Variants {
    model: Quickshell.screens
    PanelWindow {
        id: bar
        required property var modelData
        screen: modelData
        visible: true

        property alias barVisible: bar.visible

        exclusionMode: ExclusionMode.Normal
        exclusiveZone: morphPill.restHeight + Config.barMarginV

        anchors {
            top: true
            left: true
            right: true
        }
        color: "transparent"
        implicitHeight: morphPill.implicitHeight + Config.barMarginV * 2
 
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
