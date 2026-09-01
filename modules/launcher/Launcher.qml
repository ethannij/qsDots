import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.services
import qs.config
import qs.theme

Item {
    id: launcher
    property string query: ""
    property alias searchField: input

    function launchSelected() {
        const apps = filtered.values;
        const idx = list.currentIndex;
        if (idx < 0 || idx >= apps.length)
            return;
        const app = apps[idx];
        if (app && app.execute)
            app.execute();
        PillController.closeLauncher();
    }

    function reset() {
        query = "";
        input.text = "";
        list.currentIndex = 0;
    }

    onVisibleChanged: {
        if (!visible) {
            reset();
        }
    }

    ColumnLayout {
        id: column
        anchors.fill: parent
        spacing: Config.spaceSm

        RowLayout {
            IconImage {
                source: Qt.resolvedUrl("../img/launcher/search.svg")
                implicitSize: Config.iconSize
            }

            TextField {
                id: input
                Layout.fillWidth: true
                placeholderText: "Search..."
                font: StylizedFont.body
                color: Colors.md3.on_surface
                focus: true
                onAccepted: launcher.launchSelected()

                Keys.onShortcutOverride: event => {
                    event.accepted = (event.key === Qt.Key_Escape)
                }

                Keys.onEscapePressed: event => {
                    event.accepted = true
                    PillController.closeLauncher()
                }
                onTextChanged: {
                    launcher.query = text;
                    list.currentIndex = filtered.values.length > 0 ? 0 : -1;
                }
                onEnabledChanged: {
                    if (enabled)
                        input.forceActiveFocus();
                }

                background: Rectangle {
                    border.width: 0
                    color: "transparent"
                    radius: Config.radiusPill
                }
                Keys.onPressed: event => {
                    if (event.key == Qt.Key_Up) {
                        event.accepted = true;
                        if (list.currentIndex > 0)
                            list.currentIndex--;
                    } else if (event.key == Qt.Key_Down) {
                        event.accepted = true;
                        if (list.currentIndex < list.count - 1)
                            list.currentIndex++;
                    } 
                }
            }
        }
        ScriptModel {
            id: filtered
            values: {
                const allEntries = [...DesktopEntries.applications.values];
                const q = launcher.query.trim();

                if (q === "") {
                    return allEntries;
                } else {
                    return allEntries.filter(d => d.name && d.name.toLowerCase().includes(q));
                }
            }
        }

        ListView {
            id: list
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: filtered.values
            currentIndex: 0
            keyNavigationWraps: true
            preferredHighlightBegin: 0
            preferredHighlightEnd: height
            highlightRangeMode: ListView.ApplyRange
            highlightMoveDuration: 80
            highlight: Rectangle {
                radius: 4
                opacity: 0.45
                color: Colors.md3.primary
            }

            delegate: Item {
                id: entry
                required property var modelData
                required property int index
                width: ListView.view.width
                height: 36

                MouseArea {
                    anchors.fill: parent
                    onClicked: list.currentIndex = entry.index
                    onDoubleClicked: launcher.launchSelected()
                }

                Row {
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 10

                    IconImage {
                        source: Quickshell.iconPath(entry.modelData.icon, true)
                        width: 23
                        height: 23
                    }

                    Text {
                        id: label
                        color: "white"
                        text: modelData.name
                        font.pointSize: 13
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
            Keys.onReturnPressed: launcher.launchSelected()
        }
    }
}
