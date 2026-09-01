//@ pragma UseQApplication
import Quickshell
import QtQuick
import qs.modules
import qs.modules.launcher
import qs.services
import QtQuick.Controls
import Quickshell.Hyprland
import QtQuick.Layouts
import Quickshell.Widgets

ShellRoot {
    id: root
    ControlBar {}

    FloatingWindow {
        id: launcher
        visible: false
        implicitWidth: 300
        implicitHeight: 300
        title: "Test Window"
        color: "black"

        property string query: ""

        function launchSelected() {
            if (list.currentItem && list.currentItem.modelData) {
                list.currentItem.modelData.execute();
            }
        }

        ColumnLayout {
            anchors.fill: parent
            spacing: 8

            RowLayout {
                Text {
                    color: "white"
                    text: "!!!!"
                    font.pointSize: 20
                }
                TextField {
                    id: input
                    Layout.fillWidth: true
                    placeholderText: "Search..."
                    font.pixelSize: 18
                    color: "white"
                    focus: true
                    onTextChanged: {
                        launcher.query = text;
                        list.currentIndex = filtered.values.length > 0 ? 0 : -1;
                    }

                    background: Rectangle {
                        border.width: 1
                        color: "transparent"
                    }

                    Keys.onPressed: event => {
                        const ctrl = event.modifiers & Qt.ControlModifier;
                        if (event.key == Qt.Key_Up || event.key == Qt.Key_P && ctrl) {
                            event.accepted = true;
                            if (list.currentIndex > 0)
                                list.currentIndex--;
                        } else if (event.key == Qt.Key_Down || event.key == Qt.Key_N && ctrl) {
                            event.accepted = true;
                            if (list.currentIndex < list.count - 1)
                                list.currentIndex++;
                        } else if ([Qt.Key_Return, Qt.Key_Enter].includes(event.key)) {
                            event.accepted = true;
                            launcher.launchSelected();
                        } else if (event.key == Qt.Key_C && ctrl) {
                            event.acepted = true;
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
                currentIndex: filtered.values.length > 0 ? 0 : -1
                keyNavigationWraps: true
                preferredHighlightBegin: 0
                preferredHighlightEnd: height
                highlightRangeMode: ListView.ApplyRange
                highlightMoveDuration: 80
                highlight: Rectangle {
                    radius: 4
                    opacity: 0.45
                    color: "yellow"
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
                            source: Quickshell.iconPath(modelData.icon, true)
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
}
