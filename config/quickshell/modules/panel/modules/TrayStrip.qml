import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import qs.config

Row {
    id: root

    spacing: Config.spaceSm

    Repeater {
        model: SystemTray.items

        IconImage {
            id: icon

            required property var modelData

            source: modelData.icon
            implicitSize: Config.trayIconSize

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

                // Click actions for tray icons
                onClicked: mouse => {
                    if (mouse.button === Qt.LeftButton)
                        icon.modelData.activate();
                    else if (mouse.button === Qt.MiddleButton)
                        icon.modelData.secondaryActivate();
                    else if (mouse.button === Qt.RightButton)
                        menuAnchor.open();
                }

                // Scroll for tray icons that support it
                onWheel: wheel => {
                    if (wheel.angleDelta.y !== 0)
                        icon.modelData.scroll(wheel.angleDelta.y, false);
                    if (wheel.angleDelta.x !== 0)
                        icon.modelData.scroll(wheel.angleDelta.x, true)
                }

                QsMenuAnchor {
                    id: menuAnchor
                    menu: icon.modelData.menu
                    anchor.item: icon
                }
            }

        }
    }
}
