import QtQuick
import Quickshell
import Quickshell.Io
import QtQuick.Layouts
import qs.services
import qs.modules.elements
import qs.theme
import qs.config

PillShape {
    id: gamebar

    onVisibleChanged: if (!visible)
        gamebar.fpsOpen = false

    QtObject {
        id: screenshot
        property url icon: Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/gamebar/screenshot.svg"))
        function trigger() {
            Quickshell.execDetached(["flameshot", "gui"]);
        }
    }
    QtObject {
        id: record
        property url icon: Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/gamebar/screenrecord.svg"))
        function trigger() {
            Quickshell.execDetached(["bash", "-c", `
        pidfile="$HOME/.cache/gpu-screen-recorder-gamebar.pid"
        if [ -f "$pidfile" ]; then
            pid=$(cat "$pidfile")
            if kill -0 "$pid" 2>/dev/null; then
                kill -INT "$pid"
                rm -f "$pidfile"
                exit 0
            else
                rm -f "$pidfile"
            fi
        fi
        mkdir -p "$HOME/Videos/gpu-screen-recorder"
        gpu-screen-recorder \
            -w portal \
            -c mkv \
            -a default_output \
            -k av1 \
            -bm cbr \
            -q 5000 \
            -o "$HOME/Videos/gpu-screen-recorder/$(date +"Video_%Y-%m-%d_%I-%M-%p.mkv")" \
            >/dev/null 2>&1 &
        echo $! > "$pidfile"
    `]);
        } // literally a copy paste from the rofi configuration
    }
    QtObject {
        id: mangohud
        property url icon: Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/gamebar/mangohud.svg"))
        function trigger() {
        }
    }
    QtObject {
        id: systemMonitor
        property url icon: Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/gamebar/systemMonitor.svg"))
        function trigger() {
            Quickshell.execDetached(["missioncenter"]);
        }
    }
    QtObject {
        id: help
        property url icon: Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/gamebar/help.svg"))
        function trigger() {
        }
    }

    property bool fpsOpen: false

    Column {
        id: column
        spacing: Config.spaceSm
        anchors.verticalCenter: parent.verticalCenter

        Row {
            id: row
            spacing: Config.spaceSm
            visible: !gamebar.fpsOpen

            Repeater {
                id: repeater
                model: [screenshot, record, mangohud, systemMonitor, help]

                delegate: IconButton {
                    id: icon

                    required property var modelData
                    source: modelData.icon
                    size: Config.iconSize
                    iconColor: hover.hovered ? Colors.md3.primary : Colors.md3.on_surface
                    backgroundColor: hover.hovered ? Colors.md3.surface_variant : "transparent"

                    Behavior on backgroundColor {
                        ColorAnimation {
                            duration: Config.animMs
                            easing.type: Easing.OutCubic
                        }
                    }

                    Behavior on iconColor {
                        ColorAnimation {
                            duration: Config.animMs
                            easing.type: Easing.OutCubic
                        }
                    }

                    HoverHandler {
                        id: hover
                        cursorShape: Qt.PointingHandCursor
                    }
                    TapHandler {
                        id: tap
                        onTapped: {
                            if (modelData === mangohud) {
                                gamebar.fpsOpen = !gamebar.fpsOpen;
                                return;
                            }
                            modelData.trigger();
                            PillController.releaseGamebar();
                        }
                    }
                }
            }
        }

        Row {
            id: fpsList
            visible: gamebar.fpsOpen
            spacing: Config.spaceSm

            Repeater {
                model: [0, 60, 90, 120, 240]

                delegate: Item {
                    id: fpsItem
                    required property int modelData

                    implicitWidth: background.implicitWidth + Config.spaceSm
                    implicitHeight: background.implicitHeight + Config.spaceSm

                    Rectangle {
                        id: background
                        anchors.centerIn: parent
                        implicitWidth: fpsText.implicitWidth + Config.spaceMd
                        implicitHeight: fpsText.implicitHeight + Config.spaceMd
                        radius: Config.radiusPill
                        color: listHover.hovered ? Colors.md3.surface_variant : "transparent"

                        Text {
                            id: fpsText
                            anchors.centerIn: parent
                            text: fpsItem.modelData === 0 ? "" : modelData
                            font: StylizedFont.body
                            color: listHover.hovered ? Colors.md3.primary : Colors.md3.on_surface

                            Behavior on color {
                                ColorAnimation {
                                    duration: Config.animMs
                                    easing.type: Easing.OutCubic
                                }
                            }
                            
                            HoverHandler {
                                id: listHover
                                cursorShape: Qt.PointingHandCursor
                            }
                            TapHandler {
                                id: listTap
                                gesturePolicy: TapHandler.ReleaseWithinBounds
                                onTapped: {
                                    gamebar.applyLimit(fpsItem.modelData);
                                    PillController.releaseGamebar();
                                }
                            }
                        }
                        Behavior on color {
                            ColorAnimation {
                                duration: Config.animMs
                                easing.type: Easing.OutCubic
                            }
                        }
                    }
                }
            }
        }
    }

    FileView {
        id: mangoConf
        path: Quickshell.env("HOME") + "/.config/MangoHud/MangoHud.conf"
        watchChanges: true
        atomicWrites: true
        onFileChanged: reload()
    }

    function applyLimit(fps) {
        if (!mangoConf.loaded)
            return;
        const next = mangoConf.text().replace(/^fps_limit=.*/m, "fps_limit=" + fps);
        if (next !== mangoConf.text())
            mangoConf.setText(next);
    }
}
