import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.services
import Quickshell.Io
import qs.config
import qs.theme
import qs.modules.bar
import qs.modules.panel.modules
import qs.modules.elements

/*Item {
    id: controlPanel
    width: Config.controlPanelW - Config.controlPanelPadding * 2
    height: Config.controlPanelH - Config.controlPanelPadding * 2
    visible: opacity > 0

    property string page: PillController.page
    property bool panelOpen: PillController.panelOpen
    property bool layerEnabled: false

    onOpacityChanged: {
        if (opacity === 0 && !PillController.panelOpen)
            PillController.page = "home";
    }

    onVisibleChanged: {
        WLED.refresh();
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

        Text {
            id: userText
            anchors.left: parent.left
            anchors.leftMargin: Config.spaceMd
            anchors.verticalCenter: parent.verticalCenter
            text: Quickshell.env("USER")
            font: StylizedFont.body
            color: Colors.md3.on_surface
        }

        IconButton {
            id: wallpapers
            source: Wallpapers.icon
            backgroundColor: wallpapersHover.hovered ? Colors.md3.surface_variant : "transparent"
            iconColor: wallpapersHover.hovered ? Colors.md3.primary : Colors.md3.on_surface
            anchors.left: userText.right
            anchors.leftMargin: Config.spaceMd
            anchors.verticalCenter: parent.verticalCenter

            HoverHandler {
                id: wallpapersHover
                cursorShape: Qt.PointingHandCursor
            }
            TapHandler {
                id: wallpapersTap
                gesturePolicy: TapHandler.ReleaseWithinBounds
                onTapped: PillController.showWallpaperSwitcher()
            }
        }

        Clock {
            id: clock
            chrome: false
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
        }

        WeatherInfo {
            id: weatherInfo
            anchors.right: sessionMenu.left
            anchors.left: clock.right
            anchors.verticalCenter: parent.verticalCenter
        }

        SessionMenu {
            id: sessionMenu
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
            visible: PillController.page === "home"
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
        }

        IconButton {
            id: arrowRight
            visible: PillController.page === "home"
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            source: Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/ui/pageright.svg"))
            size: Config.iconSize * 1.2
            backgroundWidth: size
            backgroundHeight: size
            backgroundColor: arrowRightHover.hovered ? Colors.md3.surface_variant : "transparent"
            iconColor: arrowRightHover.hovered ? Colors.md3.primary : Colors.md3.on_surface

            HoverHandler {
                id: arrowRightHover
                cursorShape: Qt.PointingHandCursor
                enabled: parent.visible
            }
            TapHandler {
                id: arrowRightTap
                gesturePolicy: TapHandler.ReleaseWithinBounds
                onTapped: PillController.page = "system"
                enabled: parent.visible
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

        IconButton {
            id: arrowLeft
            visible: PillController.page === "system"
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            source: Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/ui/pageleft.svg"))
            size: Config.iconSize * 1.2
            backgroundWidth: size
            backgroundHeight: size
            backgroundColor: arrowLeftHover.hovered ? Colors.md3.surface_variant : "transparent"
            iconColor: arrowLeftHover.hovered ? Colors.md3.primary : Colors.md3.on_surface

            HoverHandler {
                id: arrowLeftHover
                cursorShape: Qt.PointingHandCursor
                enabled: parent.visible
            }
            TapHandler {
                id: arrowLeftTap
                gesturePolicy: TapHandler.ReleaseWithinBounds
                onTapped: PillController.page = "home"
                enabled: parent.visible
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
            // - Battery display of connected devices
            // - System Update (show packages to update, spawn terminal)
            // - Screenshot/Screen Record
            // - Theme/Wallpaper Picker

        }
    }

    RowLayout {
        id: footer
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottomMargin: Config.controlPanelFooterBottomInset
        anchors.leftMargin: Config.controlPanelFooterInset

        Row {
            Layout.alignment: Qt.AlignVCenter
            spacing: Config.controlPanelStatsSpacing

            SysUsage {}
            Rectangle {
                implicitWidth: 1
                implicitHeight: parent.height
                color: Colors.md3.on_surface_variant
            }
            LaptopBattery {
                Layout.alignment: Qt.AlignVCenter
                visible: Power.laptopBattery !== undefined
            }
            DeviceBattery {
                Layout.alignment: Qt.AlignVCenter
            }
        }

        RowLayout {
            id: trayRow
            //anchors.right: parent.right
            //anchors.verticalCenter: parent.verticalCenter
            Layout.alignment: Qt.AlignRight
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

            IconButton {
                id: trayBtn
                Layout.alignment: Qt.AlignVCenter
                source: Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/ui/menu.svg"))
                iconColor: trayBtnHover.hovered || PillController.trayOpen ? Colors.md3.primary : Colors.md3.on_surface
                backgroundColor: trayBtnHover.hovered || PillController.trayOpen ? Colors.md3.surface_variant : "transparent"
                size: Config.iconSize * 0.75

                HoverHandler {
                    id: trayBtnHover
                    cursorShape: Qt.PointingHandCursor
                }
                TapHandler {
                    id: trayBtnTap
                    gesturePolicy: TapHandler.ReleaseWithinBounds
                    onTapped: PillController.trayOpen = !PillController.trayOpen
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
}*/

Item {
    id: controlPanel
    width: Config.controlPanelW - Config.controlPanelPadding * 2
    height: Config.controlPanelH - Config.controlPanelPadding * 2
    visible: opacity > 0

    property string page: PillController.page
    property bool panelOpen: PillController.panelOpen
    property bool layerEnabled: false

    onOpacityChanged: {
        if (opacity === 0 && !PillController.panelOpen)
            PillController.page = "home";
    }

    onVisibleChanged: {
        WLED.refresh();
        sliders.volumeSourceMenuOpen = false;
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: Config.spaceMd

        Item {
            id: header
            z: 3
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop
            Layout.preferredHeight: Config.controlPanelHeaderHeight

            Text {
                id: userText
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                text: Quickshell.env("USER")
                font: StylizedFont.body
                color: Colors.md3.on_surface
            }

            IconButton {
                id: wallpapers
                source: Wallpapers.icon
                backgroundColor: wallpapersHover.hovered ? Colors.md3.surface_variant : "transparent"
                iconColor: wallpapersHover.hovered ? Colors.md3.primary : Colors.md3.on_surface
                anchors.left: userText.right
                anchors.leftMargin: Config.spaceMd
                anchors.verticalCenter: parent.verticalCenter

                HoverHandler {
                    id: wallpapersHover
                    cursorShape: Qt.PointingHandCursor
                }
                TapHandler {
                    gesturePolicy: TapHandler.ReleaseWithinBounds
                    onTapped: PillController.showWallpaperSwitcher()
                }
            }

            Clock {
                id: clock
                anchors.centerIn: parent
                chrome: false
                showDate: morphPill.dateShown
            }

            WeatherInfo {
                anchors.left: clock.right
                anchors.right: sessionMenu.left
                anchors.verticalCenter: parent.verticalCenter
            }

            SessionMenu {
                id: sessionMenu
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Item {
            id: sliders
            z: 2
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop
            Layout.preferredHeight: volumeSlider.implicitHeight
            Layout.maximumHeight: volumeSlider.implicitHeight

            property bool volumeSourceMenuOpen: false

            PillSlider {
                id: volumeSlider
                value: Audio.vol / 100
                from: 0
                to: 1
                stepSize: 0.05
                onMoved: Audio.setVolume(value)
                width: implicitWidth
                height: implicitHeight
                anchors.top: parent.top
                anchors.left: parent.left
                imageURL: Audio.icon

                MouseArea {
                    id: volumeSliderMouse
                    anchors.fill: parent
                    hoverEnabled: false
                    z: -1

                    onWheel: wheel => {
                        if (wheel.angleDelta.y > 0)
                            Audio.volumeUp();
                        else if (wheel.angleDelta.y < 0)
                            Audio.volumeDown();
                    }
                }
            }

            IconButton {
                id: volumeSourceIcon
                anchors.left: volumeSlider.right
                anchors.verticalCenter: brightnessSlider.verticalCenter
                anchors.margins: Config.spaceMd
                backgroundColor: volumeSourceHover.hovered ? Colors.md3.surface_variant : "transparent"
                iconColor: volumeSourceHover.hovered ? Colors.md3.primary : Colors.md3.on_surface
                source: Audio.icon
                radius: width

                Behavior on iconColor {
                    enabled: Config.animMs > 0
                    ColorAnimation {
                        duration: Config.animMs
                        easing.type: Easing.InOutCubic
                    }
                }

                Behavior on backgroundColor {
                    enabled: Config.animMs > 0
                    ColorAnimation {
                        duration: Config.animMs
                        easing.type: Easing.InOutCubic
                    }
                }

                HoverHandler {
                    id: volumeSourceHover
                    cursorShape: Qt.PointingHandCursor
                }

                TapHandler {
                    id: volumeSourceTap
                    gesturePolicy: TapHandler.ReleaseWithinBounds
                    acceptedButtons: Qt.LeftButton
                    onTapped: {
                        sliders.volumeSourceMenuOpen = !sliders.volumeSourceMenuOpen;
                    }
                }

                TapHandler {
                    id: volumeSourceTapAlternate
                    gesturePolicy: TapHandler.ReleaseWithinBounds
                    acceptedButtons: Qt.RightButton
                    onTapped: Audio.toggleMute()
                }
            }

            Rectangle {
                id: volumeSourceMenu
                width: 232
                height: sinkList.height + 8
                visible: sliders.volumeSourceMenuOpen
                color: Colors.md3.surface_container_highest
                radius: 12
                clip: true
                anchors.top: volumeSourceIcon.bottom
                anchors.topMargin: Config.spaceSm
                anchors.left: volumeSlider.left

                function sinkLabel(node) {
                    const raw = node.description || node.nickname || node.name;
                    return raw.replace(/\s+(Analog|Digital|Pro Audio|Mono|Multichannel).*$/, "");
                }

                ListView {
                    id: sinkList
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: 4
                    height: contentHeight
                    model: Audio.sinks
                    spacing: 2
                    interactive: false
                    clip: true

                    delegate: Item {
                        id: sinkRow
                        required property var modelData
                        width: ListView.view.width
                        height: 36
                        readonly property bool active: modelData === Audio.sink

                        Rectangle {
                            anchors.fill: parent
                            radius: 8
                            color: sinkHover.hovered ? Colors.md3.surface_bright : "transparent"
                        }

                        ColorizedIcon {
                            id: speaker
                            anchors.left: parent.left
                            anchors.leftMargin: 10
                            anchors.verticalCenter: parent.verticalCenter
                            source: Qt.resolvedUrl(Quickshell.shellPath("modules/img/audio/high.svg"))
                            size: 18
                            color: sinkRow.active ? Colors.md3.primary : Colors.md3.on_surface_variant
                        }

                        Text {
                            anchors.left: speaker.right
                            anchors.leftMargin: 10
                            anchors.right: check.left
                            anchors.rightMargin: 8
                            anchors.verticalCenter: parent.verticalCenter
                            text: volumeSourceMenu.sinkLabel(sinkRow.modelData)
                            font: StylizedFont.tooltip
                            color: sinkRow.active ? Colors.md3.primary : Colors.md3.on_surface
                            elide: Text.ElideRight
                        }

                        Item {
                            id: check
                            width: 16
                            height: 16
                            anchors.right: parent.right
                            anchors.rightMargin: 10
                            anchors.verticalCenter: parent.verticalCenter

                            Text {
                                anchors.centerIn: parent
                                visible: sinkRow.active
                                text: "\u2713"
                                color: Colors.md3.primary
                                font: StylizedFont.tooltip
                            }
                        }

                        HoverHandler {
                            id: sinkHover
                            cursorShape: Qt.PointingHandCursor
                        }

                        TapHandler {
                            onTapped: {
                                Audio.setDefaultSink(sinkRow.modelData);
                                sliders.volumeSourceMenuOpen = false;
                            }
                        }
                    }
                }
            }

            IconButton {
                id: tempIcon
                anchors.right: brightnessSlider.left
                anchors.verticalCenter: brightnessSlider.verticalCenter
                anchors.margins: Config.spaceMd
                backgroundColor: mouseIcon.containsMouse ? Colors.md3.surface_variant : "transparent"
                iconColor: Colors.md3.on_surface
                source: Hyprsunset.activeTemperatureIconURL
                radius: width

                MouseArea {
                    id: mouseIcon
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        Hyprsunset.temperatureNext();
                    }
                }
            }

            PillSlider {
                id: brightnessSlider
                width: implicitWidth
                height: implicitHeight
                anchors.top: parent.top
                anchors.right: parent.right

                from: Hyprsunset.gammaLowerLimit
                to: Hyprsunset.gammaUpperLimit
                value: Hyprsunset.gamma
                onValueChanged: Hyprsunset.setGamma(value)
                handleVisible: true
                imageURL: Hyprsunset.brightnessIconURL
                MouseArea {
                    id: mouse
                    anchors.fill: parent
                    hoverEnabled: false
                    z: -1

                    onWheel: wheel => {
                        if (wheel.angleDelta.y > 0)
                            Hyprsunset.gammaUp();
                        else if (wheel.angleDelta.y < 0)
                            Hyprsunset.gammaDown();
                    }
                }
            }
        }

        Widgets {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop
            Layout.preferredHeight: implicitHeight
            Layout.maximumHeight: implicitHeight
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 168
            Layout.maximumHeight: 168
            radius: 12
            color: Colors.md3.surface_container_highest

            MediaPlayer {
                id: mediaPlayer
                anchors.fill: parent
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Text {
                id: notifLabel
                anchors.left: parent.left
                anchors.top: parent.top
                text: "Notifications"
                font: StylizedFont.tooltip
                color: Colors.md3.on_surface_variant
            }

            Text {
                id: clearNotifs
                anchors.right: parent.right
                anchors.verticalCenter: notifLabel.verticalCenter
                visible: Notifications.count > 0
                text: "Clear"
                font: StylizedFont.tooltip
                color: clearNotifsHover.hovered ? Colors.md3.primary : Colors.md3.on_surface_variant

                HoverHandler {
                    id: clearNotifsHover
                    cursorShape: Qt.PointingHandCursor
                }

                TapHandler {
                    onTapped: Notifications.clearAll()
                }
            }

            NotificationList {
                anchors.top: notifLabel.bottom
                anchors.topMargin: Config.spaceSm
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignBottom
            spacing: Config.spaceSm

            Row {
                Layout.alignment: Qt.AlignVCenter
                spacing: Config.controlPanelStatsSpacing

                SysUsage {}
                Rectangle {
                    implicitWidth: 1
                    implicitHeight: parent.height
                    color: Colors.md3.on_surface_variant
                }
                LaptopBattery {
                    visible: Power.laptopBattery !== undefined
                }
                DeviceBattery {}
            }

            Item {
                Layout.fillWidth: true
            }

            RowLayout {
                Layout.alignment: Qt.AlignVCenter
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

                IconButton {
                    Layout.alignment: Qt.AlignVCenter
                    source: Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/ui/menu.svg"))
                    iconColor: trayBtnHover.hovered || PillController.trayOpen ? Colors.md3.primary : Colors.md3.on_surface
                    backgroundColor: trayBtnHover.hovered || PillController.trayOpen ? Colors.md3.surface_variant : "transparent"
                    size: Config.iconSize * 0.75

                    HoverHandler {
                        id: trayBtnHover
                        cursorShape: Qt.PointingHandCursor
                    }
                    TapHandler {
                        gesturePolicy: TapHandler.ReleaseWithinBounds
                        onTapped: PillController.trayOpen = !PillController.trayOpen
                    }
                }
            }
        }
    }

    IpcHandler {
        target: "ipcPanel"
        function toggleControlPanel(): void {
            if (PillController.panelOpen)
                PillController.closePanel();
            else
                PillController.showPanel();
        }
    }
}
