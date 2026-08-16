import QtQuick
import Quickshell
import qs.modules.elements
import qs.services
import Quickshell.Io
import qs.config
import qs.theme
import QtQuick.Layouts
import qs.modules.bar
import qs.modules.panel.modules


Item {
    id: controlPanel
    anchors.fill: parent
    anchors.margins: Config.pillPadH
    enabled: PillController.panelOpen
    opacity: PillController.panelOpen ? 1 : 0
    

    Behavior on opacity {
        NumberAnimation {
            duration: Config.animMs
            easing.type: Easing.InOutCubic
        }
    }

    Item {
        id: header
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 40
        anchors.leftMargin: Config.pillPadH
        anchors.rightMargin: Config.pillPadH

        Text {
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        text: Quickshell.env("USER")
        font {
            family: Config.fontFamilyPropo
            pointSize: Config.fontSize
            weight: Config.fontWeight
        }
        color: Colors.md3.on_surface
    }

    Clock {
        chrome: false
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
    }

    SessionMenu {
        anchors.right: parent.right
        anchors.rightMargin: 0
    }
    }

    Item {
        id: body
        anchors.top: header.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: footer.top
        anchors.topMargin: 12
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "BODY"
            font {
                family: Config.fontFamilyPropo
                pointSize: 48
                weight: Config.fontWeight
            }
            color: Colors.md3.on_surface
            }
        }

    Item {
        id: footer
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottomMargin: Config.pillPadH * 2
        anchors.leftMargin: Config.pillPadH

        Row {
            spacing: Config.widgetSpacing * 8
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
        CPUInfo {
            id: cpuInfo
            color: Colors.md3.primary
        }

        MemInfo {
            id: memInfo
            color: Colors.md3.secondary
        }

        GPUInfo {
            id: gpuInfo
            color: Colors.md3.tertiary
        }
        }

        }
    
    


    IpcHandler {
        id: ipcPanel
        target: "ipcPanel"
        function toggleControlPanel(): void {
            if (PillController.panelOpen)
                PillController.closePanel()
            else
                PillController.showPanel();
           }
    }
}