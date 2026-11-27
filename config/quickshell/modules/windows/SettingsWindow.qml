import QtQuick
import QtQuick.Controls
import Quickshell
import qs.theme
import qs.services
import qs.config
import qs.modules.elements

Window {
    id: root

    title: "QsDots Settings" // Title so we can use hyprland rules

    width: 1200
    height: 800
    visible: PillController.settingsWindowOpen
    //visible: true // -- debug
    onVisibleChanged: {
        if (visible) {
            return;
        } else if (!visible) {
            PillController.settingsWindowOpen = false;
        }
    }

    property string activeTab: "General"

    ListModel {
        id: settingsModel
        ListElement {
            title: "General"
        }
        ListElement {
            title: "Appearance"
        }
        ListElement {
            title: "Behavior"
        }
        ListElement {
            title: "Advanced"
        }
    }

    Rectangle {
        id: rect
        anchors.fill: parent
        color: Colors.md3.surface

        clip: true

        Row {
            anchors.topMargin: Config.spaceXl
            spacing: Config.spaceMd
            anchors.margins: Config.spaceMd
            anchors.fill: parent

            ListView {
                id: settingsListView
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: 200
                model: settingsModel
                spacing: Config.spaceMd
                delegate: PillShape {
                    id: settingsItem
                    required property string title
                    property bool active: root.activeTab === title
                    width: parent.width

                    radius: height / 2
                    color: active ? Colors.md3.primary_container : hovered ? Colors.role.hover : Colors.role.chip
                    borderColor: active || hovered ? Colors.md3.primary : "transparent"

                    onTapped: {
                        root.activeTab = title;
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: Config.animMs
                            easing.type: Easing[Config.animEasingOut]
                        }
                    }

                    Behavior on borderColor {
                        ColorAnimation {
                            duration: Config.animMs
                            easing.type: Easing[Config.animEasingOut]
                        }
                    }

                    Text {
                        id: settingsItemText
                        text: settingsItem.title
                        font: StylizedFont.title
                        color: settingsItem.active ? Colors.md3.on_primary_container : Colors.md3.on_surface

                        Behavior on color {
                            ColorAnimation {
                                duration: Config.animMs
                                easing.type: Easing[Config.animEasingOut]
                            }
                        }
                    }
                }
            }

            Rectangle {
                id: contentRect
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                width: parent.width - settingsListView.width - Config.spaceMd
                color: Colors.role.panel
                radius: Config.radiusPill

                clip: true

                Item {
                    id: generalPage
                    anchors.fill: parent
                    visible: root.activeTab === "General"
                    anchors.margins: Config.spaceMd

                    Column {
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: Config.spaceXl

                        Item {
                            id: clockSettings
                            implicitWidth: generalPage.width
                            implicitHeight: clockTitle.height + clockRow.height
                            Text {
                                id: clockTitle
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: "Clock"
                                font: StylizedFont.title
                                color: Colors.md3.on_surface
                            }
                            Row {
                                id: clockRow
                                spacing: Config.spaceMd
                                anchors.top: clockTitle.bottom
                                Text {
                                    text: "24 Hour Clock"
                                    font: StylizedFont.bold
                                    color: Colors.md3.on_surface
                                }
                                PillSwitch {
                                    id: twentyFourHourClockSwitch
                                    checked: States.twentyFourHourClock
                                    onCheckedChanged: {
                                        States.twentyFourHourClock = checked;
                                    }
                                }
                            }
                        }

                        Item {
                            id: workspacesSettings
                            implicitWidth: generalPage.width
                            implicitHeight: workspacesTitle.height + workspacesRow.height
                            Text {
                                id: workspacesTitle
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: "Workspaces"
                                font: StylizedFont.title
                                color: Colors.md3.on_surface
                            }

                            Row {
                                id: workspacesRow
                                spacing: Config.spaceMd
                                anchors.top: workspacesTitle.bottom
                                Text {
                                    id: workspaceCountText
                                    text: "Workspace Count"
                                    font: StylizedFont.bold
                                    color: Colors.md3.on_surface
                                }

                                UserInput {
                                    id: workspaceCountInput
                                    anchors.verticalCenter: workspaceCountText.verticalCenter
                                    text: States.workspaceCount
                                    onAccepted: {
                                        const n = parseInt(text, 10);
                                        if (Number.isFinite(n) && n > 0)
                                            States.workspaceCount = n;
                                        else
                                            States.workspaceCount = 5;
                                        focus = false;
                                    }

                                    Keys.onEscapePressed: {
                                        text = States.workspaceCount > 0 ? String(States.workspaceCount) : "";
                                    }

                                    Keys.onEnterPressed: {
                                        accepted();
                                        focus = false;
                                    }
                                }
                            }
                        }

                        Item {
                            id: wallpaperSettings
                            implicitWidth: generalPage.width
                            implicitHeight: wallpaperTitle.height + wallpaperRow.height

                            Text {
                                id: wallpaperTitle
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: "Wallpaper"
                                font: StylizedFont.title
                                color: Colors.md3.on_surface
                            }

                            Column {
                                id: wallpaperColumn
                                spacing: Config.spaceMd
                                anchors.top: wallpaperTitle.bottom

                                Row {
                                    id: wallpaperRow
                                    spacing: Config.spaceMd

                                    Text {
                                        id: wallpaperCycleSecondsText
                                        text: "Wallpaper Cycle Seconds"
                                        font: StylizedFont.bold
                                        color: Colors.md3.on_surface
                                    }

                                    UserInput {
                                        id: wallpaperCycleSecondsInput
                                        anchors.verticalCenter: wallpaperCycleSecondsText.verticalCenter
                                        text: States.wallpaperCycleSeconds
                                        onAccepted: {
                                            const n = parseInt(text, 10);
                                            if (Number.isFinite(n) && n > 0)
                                                Wallpapers.startCycle(n);
                                            else
                                                Wallpapers.stopCycle();
                                            focus = false;
                                        }

                                        Keys.onEscapePressed: {
                                            text = Wallpapers.cycleSeconds > 0 ? String(Wallpapers.cycleSeconds) : "";
                                        }

                                        Keys.onEnterPressed: {
                                            accepted();
                                            focus = false;
                                        }
                                    }
                                }

                                Row {
                                    id: wallpaperDirectoryRow
                                    spacing: Config.spaceMd
                                    Text {
                                        id: wallpaperDirectoryText
                                        text: "Wallpaper Directory"
                                        font: StylizedFont.bold
                                        color: Colors.md3.on_surface
                                    }
                                    UserInput {
                                        id: wallpaperDirectoryInput
                                        anchors.verticalCenter: wallpaperDirectoryText.verticalCenter
                                        text: States.wallpaperDirectory
                                        onAccepted: {
                                            States.wallpaperDirectory = text;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                Item {
                    id: appearancePage
                    anchors.fill: parent
                    visible: root.activeTab === "Appearance"
                    anchors.margins: Config.spaceMd

                    function schemeName(value) {
                        if (value === "light")
                            return "Light";
                        if (value === "oled")
                            return "OLED";
                        return "Dark";
                    }

                    Text {
                        id: appearanceTitle
                        text: "Appearance"
                        font: StylizedFont.title
                        color: Colors.md3.on_surface
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                    }

                    Row {
                        id: colorSchemeRow
                        spacing: Config.spaceMd
                        anchors.left: parent.left
                        anchors.top: appearanceTitle.bottom

                        Text {
                            id: colorSchemeLabel
                            text: "Color Scheme"
                            font: StylizedFont.bold
                            color: Colors.md3.on_surface
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        DropdownMenu {
                            id: colorSchemeDropdown
                            anchors.verticalCenter: parent.verticalCenter
                            text: appearancePage.schemeName(ColorScheme.colorScheme)
                            textRole: "text"
                            direction: "down"
                            radius: Config.radiusPill
                            menuRadius: Config.radiusPill
                            borderWidth: Config.borderWidth
                            borderColor: Colors.md3.shadow
                            labelColor: Colors.md3.on_surface
                            itemColor: Colors.md3.on_surface
                            itemFont: StylizedFont.body
                            labelFont: StylizedFont.body
                            labelAlignment: Text.AlignHCenter
                            menuPadding: Config.spaceSm
                            onSelected: modelData => ColorScheme.setScheme(modelData.value)
                            model: [
                                { text: "Light", value: "light" },
                                { text: "Dark", value: "dark" },
                                { text: "OLED", value: "oled" }
                            ]
                        }
                    }
                }
                Item {
                    id: behaviorPage
                    anchors.fill: parent
                    visible: root.activeTab === "Behavior"
                    anchors.margins: Config.spaceMd

                    Column {
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: Config.spaceXl

                        Item {
                            id: batterySettings
                            implicitWidth: behaviorPage.width
                            implicitHeight: batteryTitle.height + batteryColumn.height

                            Text {
                                id: batteryTitle
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: "Battery"
                                font: StylizedFont.title
                                color: Colors.md3.on_surface
                            }

                            Column {
                                id: batteryColumn
                                spacing: Config.spaceMd
                                anchors.top: batteryTitle.bottom

                                Row {
                                    spacing: Config.spaceMd

                                    Text {
                                        text: "Show when charging or low"
                                        font: StylizedFont.bold
                                        color: Colors.md3.on_surface
                                    }

                                    PillSwitch {
                                        checked: States.pinBatteryOnAlert
                                        onCheckedChanged: States.pinBatteryOnAlert = checked
                                    }
                                }

                                Row {
                                    spacing: Config.spaceMd

                                    Text {
                                        id: batteryLowText
                                        text: "Low battery percent"
                                        font: StylizedFont.bold
                                        color: Colors.md3.on_surface
                                    }

                                    UserInput {
                                        anchors.verticalCenter: batteryLowText.verticalCenter
                                        text: States.batteryLowPercent
                                        intOnly: true
                                        onAccepted: {
                                            const n = parseInt(text, 10);
                                            if (Number.isFinite(n) && n > 0 && n < 100)
                                                States.batteryLowPercent = n;
                                            else
                                                States.batteryLowPercent = 25;
                                            focus = false;
                                        }

                                        Keys.onEscapePressed: {
                                            text = States.batteryLowPercent;
                                            focus = false;
                                        }

                                        Keys.onEnterPressed: {
                                            accepted();
                                            focus = false;
                                        }
                                    }
                                }
                            }
                        }

                        Item {
                            id: pillSettings
                            implicitWidth: behaviorPage.width
                            implicitHeight: pillTitle.height + pillColumn.height

                            Text {
                                id: pillTitle
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: "Pill"
                                font: StylizedFont.title
                                color: Colors.md3.on_surface
                            }

                            Column {
                                id: pillColumn
                                spacing: Config.spaceMd
                                anchors.top: pillTitle.bottom

                                Row {
                                    spacing: Config.spaceMd

                                    Text {
                                        text: "Show volume changes"
                                        font: StylizedFont.bold
                                        color: Colors.md3.on_surface
                                    }

                                    PillSwitch {
                                        checked: States.showVolumeFace
                                        onCheckedChanged: States.showVolumeFace = checked
                                    }
                                }

                                Row {
                                    spacing: Config.spaceMd

                                    Text {
                                        text: "Show workspace changes"
                                        font: StylizedFont.bold
                                        color: Colors.md3.on_surface
                                    }

                                    PillSwitch {
                                        id: workspaceSwitch
                                        onClicked: States.showWorkspaceFace = !States.showWorkspaceFace

                                        Binding {
                                            target: workspaceSwitch
                                            property: "checked"
                                            value: States.showWorkspaceFace
                                        }
                                    }
                                }

                                Row {
                                    spacing: Config.spaceMd

                                    Text {
                                        text: "Show do not disturb"
                                        font: StylizedFont.bold
                                        color: Colors.md3.on_surface
                                    }

                                    PillSwitch {
                                        id: doNotDisturbSwitch
                                        onClicked: States.showDoNotDisturb = !States.showDoNotDisturb

                                        Binding {
                                            target: doNotDisturbSwitch
                                            property: "checked"
                                            value: States.showDoNotDisturb
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                Item {
                    id: advancedPage
                    anchors.fill: parent
                    visible: root.activeTab === "Advanced"
                    anchors.margins: Config.spaceMd

                    Text {
                        text: "Advanced"
                        font: StylizedFont.title
                        color: Colors.md3.on_surface
                    }
                }
            }
        }
    }
}
