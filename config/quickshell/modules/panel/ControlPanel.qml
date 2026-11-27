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

Item {
    id: controlPanel
    width: Config.controlPanelW - Config.controlPanelPadding * 2
    implicitHeight: {
        const content = panelColumn.implicitHeight;
        if (!sliders.volumeSourceMenuOpen)
            return content;
        return Math.max(content, volumeSourceMenu.y + volumeSourceMenu.height);
    }
    height: implicitHeight
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
        id: panelColumn
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
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
                backgroundColor: wallpapersHover.hovered ? Colors.role.hover : "transparent"
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

            LightDarkToggle {
                anchors.left: wallpapers.right
                anchors.leftMargin: Config.spaceMd
                anchors.verticalCenter: parent.verticalCenter
            }

            Clock {
                id: clock
                anchors.centerIn: parent
                chrome: false
                showDate: morphPill.dateShown
                visible: false
            }

            WeatherInfo {
                anchors.left: clock.right
                anchors.right: settingsButton.left
                anchors.verticalCenter: parent.verticalCenter
            }

            SettingsButton {
                id: settingsButton
                anchors.rightMargin: Config.spaceMd
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: sessionMenu.left
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
                backgroundColor: volumeSourceHover.hovered ? Colors.role.hover : "transparent"
                iconColor: volumeSourceHover.hovered ? Colors.md3.primary : Colors.md3.on_surface
                source: Audio.icon
                radius: width

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

            IconButton {
                id: tempIcon
                anchors.right: brightnessSlider.left
                anchors.verticalCenter: brightnessSlider.verticalCenter
                anchors.margins: Config.spaceMd
                backgroundColor: mouseIcon.containsMouse ? Colors.role.hover : "transparent"
                iconColor: mouseIcon.containsMouse ? Colors.md3.primary : Colors.md3.on_surface
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
            Layout.alignment: Qt.AlignTop
            Layout.preferredHeight: 168
            Layout.maximumHeight: 168
            radius: 12
            color: Colors.role.raised
            property real playerVisible: Media.active ? 1 : 0
            opacity: playerVisible
            visible: playerVisible > 0

            Behavior on opacity {
                enabled: Config.animMs > 0
                NumberAnimation {
                    duration: Config.animMs
                    easing.type: Easing[Config.animEasing]
                }
            }

            MediaPlayer {
                id: mediaPlayer
                anchors.fill: parent
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop
            spacing: Config.spaceSm

            RowLayout {
                Layout.alignment: Qt.AlignVCenter
                Layout.leftMargin: Config.spaceMd
                spacing: Config.controlPanelStatsSpacing

                SysUsage {
                    Layout.alignment: Qt.AlignVCenter
                }

                Rectangle {
                    Layout.preferredWidth: 1
                    Layout.preferredHeight: Math.max(1, parent.height - Config.spaceSm)
                    Layout.alignment: Qt.AlignVCenter
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
                            easing.type: Easing[Config.animEasing]
                        }
                    }
                }

                IconButton {
                    Layout.alignment: Qt.AlignVCenter
                    source: Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/ui/menu.svg"))
                    iconColor: trayBtnHover.hovered || PillController.trayOpen ? Colors.md3.primary : Colors.md3.on_surface
                    backgroundColor: trayBtnHover.hovered || PillController.trayOpen ? Colors.role.hover : "transparent"
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

        Item {
            id: notificationContainer

            property bool notificationsOpen: false
            property bool holdClosed: false
            property bool listStateReady: false

            function restoreList() {
                if (listStateReady || !States.ready)
                    return;
                holdClosed = States.notificationListHeldClosed;
                notificationsOpen = Notifications.count > 0 && !holdClosed;
                listStateReady = true;
            }

            readonly property real headerHeight: notifHeader.height
            readonly property real listGap: Config.spaceSm
            readonly property real wellPad: Config.spaceSm
            readonly property real openListHeight: notificationList.implicitHeight + wellPad * 2
            readonly property real sectionHeight: headerHeight + listGap + openListHeight
            property real shownHeight: notificationsOpen ? sectionHeight : headerHeight

            function syncOpen() {
                if (!listStateReady)
                    return;
                if (Notifications.count === 0) {
                    holdClosed = false;
                    notificationsOpen = false;
                    return;
                }
                if (!holdClosed)
                    notificationsOpen = true;
            }

            function toggleOpen() {
                if (Notifications.count === 0)
                    return;
                notificationsOpen = !notificationsOpen;
                holdClosed = !notificationsOpen;
            }

            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop
            Layout.preferredHeight: shownHeight
            Layout.maximumHeight: shownHeight
            Layout.minimumHeight: shownHeight
            implicitHeight: shownHeight
            clip: true

            Connections {
                target: Notifications
                function onCountChanged() {
                    notificationContainer.syncOpen();
                }
            }

            Connections {
                target: States
                function onReadyChanged() {
                    notificationContainer.restoreList();
                }
            }

            Component.onCompleted: restoreList()

            onHoldClosedChanged: if (listStateReady)
                States.notificationListHeldClosed = holdClosed

            // InOutBack overshoots and makes MorphPill travelH jump; keep this linear-ish.
            Behavior on shownHeight {
                enabled: Config.animMs > 0
                NumberAnimation {
                    duration: Config.animMs
                    easing.type: Easing[Config.animEasingSmooth]
                }
            }

            Item {
                id: notifHeader
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                height: Math.max(notifLabel.implicitHeight, notifActions.implicitHeight)

                Text {
                    id: notifLabel
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Notifications"
                    font: StylizedFont.tooltip
                    color: Colors.role.muted
                }

                Text {
                    id: notifCount
                    anchors.left: notifLabel.right
                    anchors.leftMargin: Config.spaceSm
                    anchors.verticalCenter: parent.verticalCenter
                    visible: Notifications.count > 0 && !notificationContainer.notificationsOpen
                    text: Notifications.count
                    font: StylizedFont.tooltip
                    color: Colors.md3.tertiary
                }

                Row {
                    id: notifActions
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: Config.spaceSm

                    Text {
                        id: clearNotifs
                        anchors.verticalCenter: parent.verticalCenter
                        visible: Notifications.count > 0
                        text: "Clear"
                        font: StylizedFont.tooltip
                        color: clearNotifsHover.hovered ? Colors.role.accent : Colors.role.muted

                        HoverHandler {
                            id: clearNotifsHover
                            cursorShape: Qt.PointingHandCursor
                        }

                        TapHandler {
                            onTapped: Notifications.clearAll()
                        }
                    }

                    IconButton {
                        id: dndButton
                        anchors.verticalCenter: parent.verticalCenter
                        size: Config.barIconSize
                        source: Qt.resolvedUrl(Quickshell.shellPath(Notifications.doNotDisturb ? "modules/img/widgets/notifications/notification_paused.svg" : "modules/img/widgets/notifications/notification.svg"))
                        iconColor: Notifications.doNotDisturb || dndHover.hovered ? Colors.role.accent : Colors.role.muted
                        backgroundColor: dndHover.hovered || Notifications.doNotDisturb ? Colors.role.hover : "transparent"

                        HoverHandler {
                            id: dndHover
                            cursorShape: Qt.PointingHandCursor
                        }

                        TapHandler {
                            onTapped: Notifications.toggleDoNotDisturb()
                        }
                    }

                    IconButton {
                        id: notificationToggleIcon
                        anchors.verticalCenter: parent.verticalCenter
                        size: Config.barIconSize * 0.75
                        source: Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/bar/arrow_down.svg"))
                        iconColor: notificationToggleIconHover.hovered ? Colors.role.accent : Colors.role.muted
                        backgroundColor: notificationToggleIconHover.hovered ? Colors.role.hover : "transparent"
                        radius: width
                        rotation: notificationContainer.notificationsOpen ? 180 : 0
                        opacity: Notifications.count > 0 ? 1 : 0.35

                        Behavior on rotation {
                            enabled: Config.animMs > 0
                            NumberAnimation {
                                duration: Config.animMs
                                easing.type: Easing[Config.animEasingSmooth]
                            }
                        }

                        HoverHandler {
                            id: notificationToggleIconHover
                            cursorShape: Qt.PointingHandCursor
                            enabled: Notifications.count > 0
                        }

                        TapHandler {
                            enabled: Notifications.count > 0
                            gesturePolicy: TapHandler.ReleaseWithinBounds
                            onTapped: notificationContainer.toggleOpen()
                        }
                    }
                }
            }

            Rectangle {
                id: notificationWell
                anchors.top: notifHeader.bottom
                anchors.topMargin: notificationContainer.listGap
                anchors.left: parent.left
                anchors.right: parent.right
                height: notificationContainer.openListHeight
                radius: 12
                color: Colors.role.raised
                opacity: notificationContainer.notificationsOpen ? 1 : 0

                Behavior on opacity {
                    enabled: Config.animMs > 0
                    NumberAnimation {
                        duration: Config.animMs
                        easing.type: Easing[Config.animEasingSmooth]
                    }
                }

                NotificationList {
                    id: notificationList
                    anchors.fill: parent
                    anchors.margins: notificationContainer.wellPad
                }
            }
        }
    }

    Item {
        id: volumeSourceLayer
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: parent.height
        z: 10
        visible: sliders.volumeSourceMenuOpen

        TapHandler {
            enabled: !menuHover.hovered
            acceptedButtons: Qt.AllButtons
            gesturePolicy: TapHandler.WithinBounds
            grabPermissions: PointerHandler.CanTakeOverFromAnything
            onTapped: sliders.volumeSourceMenuOpen = false
        }

        Rectangle {
            id: volumeSourceMenu
            width: 232
            height: sinkColumn.implicitHeight + 8
            color: Colors.role.raised
            radius: 12
            clip: true
            x: volumeSlider.mapToItem(volumeSourceLayer, 0, 0).x
            y: volumeSourceIcon.mapToItem(volumeSourceLayer, 0, volumeSourceIcon.height).y + Config.spaceSm

            function sinkLabel(node) {
                const raw = node.description || node.nickname || node.name;
                return raw.replace(/\s+(Analog|Digital|Pro Audio|Mono|Multichannel).*$/, "");
            }

            HoverHandler {
                id: menuHover
            }

            TapHandler {
                acceptedButtons: Qt.AllButtons
                gesturePolicy: TapHandler.WithinBounds
                grabPermissions: PointerHandler.CanTakeOverFromAnything
            }

            Column {
                id: sinkColumn
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 4
                spacing: 2

                Repeater {
                    model: Audio.sinks

                    Item {
                        id: sinkRow
                        required property var modelData
                        width: sinkColumn.width
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
                            acceptedButtons: Qt.LeftButton
                            gesturePolicy: TapHandler.WithinBounds
                            grabPermissions: PointerHandler.CanTakeOverFromAnything
                            onTapped: {
                                Audio.setDefaultSink(sinkRow.modelData);
                                sliders.volumeSourceMenuOpen = false;
                            }
                        }
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
