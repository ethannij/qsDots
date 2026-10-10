import QtQuick
import Quickshell
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
            spacing: Config.spaceMd

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

        Column {
            id: fpsList
            visible: gamebar.fpsOpen
            spacing: Config.spaceXs
            width: row.implicitWidth

            Repeater {
                model: [0, 30, 60, 90, 120, 240]

                Text {
                    required property int modelData
                    width: fpsList.width
                    horizontalAlignment: Text.AlignHCenter
                    text: modelData === 0 ? "Unlimited" : modelData + " FPS"
                    font: StylizedFont.body
                    color: Colors.md3.on_surface
                }
            }
        }
    }
}
