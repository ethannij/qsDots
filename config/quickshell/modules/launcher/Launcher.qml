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
                    event.accepted = (event.key === Qt.Key_Escape);
                }

                Keys.onEscapePressed: event => {
                    event.accepted = true;
                    PillController.closeLauncher();
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
                function fold(s) {
                    return (s || "").toLowerCase();
                }

                function edit1(a, b) {
                    if (Math.abs(a.length - b.length) > 1)
                        return false;
                    let i = 0, j = 0, edits = 0;
                    while (i < a.length && j < b.length) {
                        if (a[i] === b[j]) {
                            i++;
                            j++;
                            continue;
                        }
                        if (++edits > 1)
                            return false;
                        if (a.length === b.length && i + 1 < a.length && j + 1 < b.length && a[i] === b[j + 1] && a[i + 1] === b[j]) {
                            i += 2;
                            j += 2;
                        } else if (a.length >= b.length) {
                            i++;
                            if (a.length === b.length)
                                j++;
                        } else {
                            j++;
                        }
                    }
                    return edits + (a.length - i) + (b.length - j) <= 1;
                }

                function scoreText(hay, q) {
                    if (!hay)
                        return 0;
                    if (hay === q)
                        return 1000;
                    if (hay.startsWith(q))
                        return 800;
                    if (hay.split(/[\s_\-./]+/).some(w => w.startsWith(q)))
                        return 700;
                    const at = hay.indexOf(q);
                    if (at >= 0)
                        return 500 - at;

                    let hi = 0, score = 0, run = 0;
                    for (let qi = 0; qi < q.length; qi++) {
                        const found = hay.indexOf(q[qi], hi);
                        if (found < 0) {
                            score = 0;
                            break;
                        }
                        const gap = found - hi;
                        run = gap === 0 ? run + 1 : 1;
                        const boundary = found === 0 || /[\s_\-./]/.test(hay[found - 1]);
                        score += 8 + run * 6 + (boundary ? 8 : 0) - gap;
                        hi = found + 1;
                    }
                    if (score > 0)
                        return score;
                    if (q.length >= 3 && edit1(hay, q))
                        return 150;
                    return 0;
                }

                function scoreEntry(entry, q) {
                    const name = fold(entry.name);
                    let best = scoreText(name, q);
                    const id = fold(entry.id).replace(/\.desktop$/, "").replace(/[._]/g, " ");
                    best = Math.max(best, Math.floor(scoreText(id, q) * 0.9));
                    best = Math.max(best, Math.floor(scoreText(fold(entry.genericName), q) * 0.6));
                    const keywords = (entry.keywords || []).join(" ");
                    best = Math.max(best, Math.floor(scoreText(fold(keywords), q) * 0.5));
                    return best;
                }

                const q = fold(launcher.query.trim());
                if (q === "")
                    return allEntries;

                return allEntries.map(entry => ({
                            entry,
                            score: scoreEntry(entry, q)
                        })).filter(row => row.score > 0).sort((a, b) => b.score - a.score || a.entry.name.length - b.entry.name.length).map(row => row.entry);
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
