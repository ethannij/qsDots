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
    width: Config.controlPanelW - Config.controlPanelPadding * 2
    height: Config.controlPanelH - Config.controlPanelPadding * 2
    anchors.centerIn: parent
    enabled: PillController.panelOpen
    opacity: PillController.panelOpen ? 1 : 0
    visible: opacity > 0

    property string page: PillController.page

    Behavior on opacity {
        NumberAnimation {
            duration: Config.animMs
            easing.type: Easing.InOutCubic
        }
    }

    onOpacityChanged: {
        if (opacity === 0 && !PillController.panelOpen)
            PillController.page = "home";
    }

    Item {
        id: header

        z: 2

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: Config.controlPanelHeaderHeight
        anchors.leftMargin: Config.controlPanelHeaderInset
        anchors.rightMargin: Config.controlPanelHeaderInset

        visible: PillController.panelOpen

        Text {
            anchors.left: parent.left
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
        visible: PillController.panelOpen

        Item {
            anchors.fill: parent
            visible: PillController.page === "home" && PillController.panelOpen
            enabled: visible

            MediaPlayer {
                id: mediaPlayer
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width * 0.85
            }
        }

        NotifButton {
            anchors.verticalCenter: parent.verticalCenter
            x: PillController.page === "home" ? 0 : parent.width - width
            visible: PillController.page !== "system"
            // TODO: Add DND function
        }

        Rectangle {
            id: arrowRight
            visible: PillController.page === "home"
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            width: Config.spaceMd
            height: Config.spaceMd
            color: "transparent"
            Text {
                anchors.centerIn: parent
                text: ">"
                font: StylizedFont.icon
                color: Colors.md3.on_surface
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: PillController.page = "system"
            }
        }

        NotificationList {
            id: notificationList
            visible: PillController.page === "notifications"
            enabled: visible
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width * 0.85
        }

        Rectangle {
            id: leftArrowHome
            width: Config.spaceMd
            height: Config.spaceMd
            color: "transparent"
            visible: PillController.page === "system"
            x: 0
            anchors.verticalCenter: parent.verticalCenter
            Text {
                anchors.centerIn: parent
                text: "<"
                font: StylizedFont.icon
                color: Colors.md3.on_surface
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: PillController.page = "home"
            }
        }

        Item {
            id: systemControl
            visible: PillController.page === "system"
            enabled: visible
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width * 0.85

            // System Controls
            // - Wifi (clickable to expand wifi menu)
            // - Bluetooth (clickable to expand bluetooth menu)

            VolumeSlider {
                id: volumeSlider
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
            }

            Widgets {
                anchors.top: volumeSlider.top
                anchors.horizontalCenter: parent.horizontalCenter
            }

            BrightnessSlider {
                id: brightnessSlider
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
            }
            // - Mic
            // - Brightness (Slider + HyprSunset)
            // - Battery display of connected devices
            // - LED Toggle
            // - Keep System Awake
            // - GameMode Toggle (disable animations)
            // - System Update (show packages to update, spawn terminal)
            // - ?? DND button
            // - Screenshot/Screen Record
            // - Theme/Wallpaper Picker

        }
    }

    Item {
        id: footer
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottomMargin: Config.controlPanelFooterBottomInset
        anchors.leftMargin: Config.controlPanelFooterInset
        visible: PillController.panelOpen

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
                PillController.closePanel();
            else
                PillController.showPanel();
        }
    }
}
