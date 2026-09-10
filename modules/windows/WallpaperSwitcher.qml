import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import qs.services
import qs.config
import qs.theme
import qs.modules.elements

Item {
    id: root

    visible: PillController.wallpaperSwitcherOpen

    property string wallpaperDirectory: Config.wallpaperDirectory
    property list<string> wallpapers: []

    Process {
        id: wallpaperFetcher

        running: true
        command: ["bash", "-c", "ls -1 " + root.wallpaperDirectory]
        stdout: StdioCollector {
            onStreamFinished: {
                const names = text.trim().split("\n").filter(s => s.length > 0);
                root.wallpapers = names;
            }
        }
    }

    ColumnLayout {
        id: ui

        anchors.fill: parent
        anchors.margins: Config.spaceMd
        spacing: Config.spaceMd

        Item {
            id: header

            implicitWidth: parent.width
            implicitHeight: title.implicitHeight + divider.implicitHeight

            Text {
                id: title

                text: "Wallpaper"
                font: StylizedFont.title
                color: Colors.md3.on_surface
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Rectangle {
                id: divider

                implicitWidth: parent.width * 0.8
                implicitHeight: 1
                color: Colors.md3.on_surface_variant
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: title.bottom
            }

            Item {
                id: stateItem

                implicitWidth: icon.implicitWidth
                implicitHeight: icon.implicitHeight

                IconButton {
                    id: icon

                    source: Wallpapers.cycleIcon
                    backgroundColor: stateHover.hovered ? Colors.md3.surface_variant : "transparent"
                    iconColor: stateHover.hovered ? Colors.md3.primary : Colors.md3.on_surface
                    anchors.verticalCenter: parent.verticalCenter
                }

                HoverHandler {
                    id: stateHover
                    cursorShape: Qt.PointingHandCursor
                }

                TapHandler {
                    id: stateTap
                    gesturePolicy: TapHandler.ReleaseWithinBounds
                    onTapped: Wallpapers.random()
                }

                TapHandler {
                    id: stateTapAlternate
                    acceptedButtons: Qt.RightButton
                    gesturePolicy: TapHandler.ReleaseWithinBounds
                    onTapped: PillController.showPanel()
                }
            }

            PillShape {
                interactive: false
                anchors.right: parent.right
                color: Colors.md3.surface_variant

                TextInput {
                    id: intervalInput
                    font: StylizedFont.body
                    width: Math.max(24, contentWidth)
                    horizontalAlignment: TextInput.AlignHCenter
                    verticalAlignment: TextInput.AlignVCenter
                    color: Colors.md3.on_surface
                    inputMethodHints: Qt.ImhDigitsOnly
                    activeFocusOnPress: true
                    focus: false

                    text: String(Wallpapers.cycleSeconds || "0")

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
                        focus = false;
                    }
                }

                // Animations for prompt
                Behavior on opacity {
                    NumberAnimation {
                        duration: Config.animMs
                        easing.type: Easing.InOutQuad
                    }
                }

                Behavior on implicitWidth {
                    NumberAnimation {
                        duration: Config.animMs
                        easing.type: Easing.InOutQuad
                    }
                }
            }
        }

        GridView {
            id: selectionList
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: root.wallpapers

            readonly property int columns: 3
            cellWidth: Math.floor(width / columns)
            cellHeight: cellWidth / 1.778

            delegate: Item {
                id: delegate
                required property string modelData

                width: GridView.view.cellWidth
                height: GridView.view.cellHeight

                Rectangle {
                    id: rect
                    anchors.fill: parent
                    anchors.margins: delegateHover.hovered ? 0 : Config.spaceSm / 2
                    clip: true

                    Behavior on anchors.margins {
                        NumberAnimation {
                            duration: Config.animMs
                            easing.type: Easing.InOutQuad
                        }
                    }

                    Image {
                        source: Wallpapers.urlFor(delegate.modelData)
                        asynchronous: true
                        fillMode: Image.PreserveAspectCrop
                        width: parent.width
                        height: parent.height
                        smooth: true
                        mipmap: true
                        sourceSize: Qt.size(Wallpapers.thumbW, Wallpapers.thumbH)
                    }
                }

                TapHandler {
                    id: delegateTap
                    gesturePolicy: TapHandler.ReleaseWithinBounds
                    onTapped: {
                        Wallpapers.apply(delegate.modelData);
                        PillController.closePanel();
                    }
                }

                HoverHandler {
                    id: delegateHover
                    cursorShape: Qt.PointingHandCursor
                }
            }
        }
    }

    IpcHandler {
        id: ipcHandler
        target: "wallpaperSwitcher"
        function toggleVisible(): void {
            PillController.toggleWallpaperSwitcher();
        }
    }
}
