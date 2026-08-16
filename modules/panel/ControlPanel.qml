import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.services
import Quickshell.Io
import qs.config
import qs.theme
import qs.modules.bar
import qs.modules.panel.modules


Item {
    id: controlPanel
    anchors.fill: parent
    anchors.margins: Config.controlPanelPadding
    enabled: PillController.panelOpen
    opacity: PillController.panelOpen ? 1 : 0

    property string page: "home"

    Connections {
        target: PillController
        function onPanelOpenChanged() {
            if (!PillController.panelOpen)
                controlPanel.page = "home"
        }
    }
    

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
        height: Config.controlPanelHeaderHeight
        anchors.leftMargin: Config.controlPanelHeaderInset
        anchors.rightMargin: Config.controlPanelHeaderInset

        Text {
            id: notifBell
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            text: controlPanel.page === "notifications" ? "󰂞" : "󰂚"
            font: StylizedFont.icon
            color: bellMouse.containsMouse || controlPanel.page === "notifications" ? Colors.md3.primary : Colors.md3.on_surface

            MouseArea {
                id: bellMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: (mouse) => {
                    if (mouse.button === Qt.RightButton)
                        Notifications.clearAll();
                    else if (mouse.button === Qt.LeftButton)
                        controlPanel.page = controlPanel.page === "notifications" ? "home" : "notifications"
            }}
        }

        Text {
            id: notifCount
    anchors.left: notifBell.right
    anchors.leftMargin: Config.spaceXs
    anchors.verticalCenter: notifBell.verticalCenter
    visible: Notifications.list.values.length > 0
    text: Notifications.count
    font: StylizedFont.tooltip
    color: Colors.md3.tertiary
}

        Text {
        anchors.left: notifCount.right
        anchors.leftMargin: Config.spaceMd
        anchors.verticalCenter: parent.verticalCenter
        text: Quickshell.env("USER")
        font: StylizedFont.body
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
        anchors.topMargin: Config.controlPanelBodyTopGap
        anchors.bottomMargin: Config.controlPanelBodyTopGap * 2

        Item {
            anchors.fill: parent
            visible: controlPanel.page === "home"
            enabled: visible

            Text {
                anchors.centerIn: parent
                text: "HOME"
                font: StylizedFont.display
                color: Colors.md3.on_surface
            }
        }

        NotificationList {
            anchors.fill: parent
            visible: controlPanel.page === "notifications"
            enabled: visible
        }
    }

    Item {
        id: footer
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottomMargin: Config.controlPanelFooterBottomInset
        anchors.leftMargin: Config.controlPanelFooterInset

        Row {
            spacing: Config.controlPanelStatsSpacing
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

        RowLayout {
            id: trayRow
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            spacing: Config.spaceSm

            TrayStrip {
                Layout.alignment: Qt.AlignVCenter
                visible: PillController.trayOpen
                opacity: PillController.trayOpen ? 1 : 0
                Behavior on opacity {
                    NumberAnimation {
                        duration: Config.animMs
                        easing.type: Easing.InOutCubic
                    }
                }
            }

            Text {
                id: trayBtn
                Layout.alignment: Qt.AlignVCenter
                text: "󰍜"
                font: StylizedFont.icon
                color: trayBtnMouse.containsMouse || PillController.trayOpen ? Colors.md3.primary : Colors.md3.on_surface
                MouseArea {
                    id: trayBtnMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: PillController.trayOpen = !PillController.trayOpen
                }
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