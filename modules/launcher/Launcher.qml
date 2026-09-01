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
                font:StylizedFont.body
                color: Colors.md3.on_surface
                focus: true
                onTextChanged: {
                    launcher.query = text
                    list.currentIndex = filtered.values.length > 0 ? 0 : -1;
                }
                onEnabledChanged: {
                    if (enabled)
                        input.forceActiveFocus()
                }

                background: Rectangle {
                    border.width: Config.borderWidth
                    color: "transparent"
                    radius: Config.radiusPill
                }
            }
        }
    }
}