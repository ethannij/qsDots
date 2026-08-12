import Quickshell
import Quickshell.Io
import QtQuick.Layouts
import QtQuick
import qs.config
import qs.modules.bar

Variants {
    model: Quickshell.screens
    PanelWindow {
        id: bar
        required property var modelData
        screen: modelData
        visible: true

        anchors {
            top: true
            left: true
            right: true
        }
        color: "transparent"
        implicitHeight: morphPill.implicitHeight + Config.barMarginV * 2
       /* RowLayout {
            id: barRow
            anchors.fill: parent
            anchors.topMargin: Config.barMarginV
            anchors.leftMargin: Config.barMarginH
            anchors.rightMargin: Config.barMarginH
            spacing: 0

            Workspaces {}

            Item {
                Layout.fillWidth: true
            }

            Volume {}

            Item {
                Layout.margins: Config.widgetSpacing
            }
            Battery {}

            Item {
                Layout.margins: Config.widgetSpacing
            }

            Tray {}

            Item {
                Layout.margins: Config.widgetSpacing
            }

            NotifButton {} 
        } */
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
