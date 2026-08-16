import Quickshell
import Quickshell.Services.SystemTray
import QtQuick
import qs.config
import qs.modules.elements
import Quickshell.Widgets
import QtQuick.Layouts

PillShape {
    id: root

    implicitHeight: Config.barHeight
    Repeater {
        model: SystemTray.items
        RowLayout {
            id: row
            required property var modelData

            Item {
                Layout.margins: Config.widgetSpacing
            }

            IconImage {
                id: icon
                source: row.modelData.icon
                implicitSize: Config.trayIconSize

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                    onClicked: mouse => {
                        if (mouse.button === Qt.LeftButton) {
                            row.modelData.activate();
                        } else if (mouse.button === Qt.MiddleButton) {
                            row.modelData.secondaryActivate();
                        } else if (mouse.button === Qt.RightButton) {
                            menuAnchor.open();
                        }
                    }

                    QsMenuAnchor {
                        id: menuAnchor
                        menu: row.modelData.menu
                        anchor.item: icon
                        anchor.edges: Edges.Bottom
                        anchor.gravity: Edges.Bottom
                    }
                }
            }
        }
    }
}
