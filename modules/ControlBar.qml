import Quickshell
import QtQuick.Layouts
import QtQuick
import qs.config
import qs.modules
import qs.modules.bar
import qs.modules.pill
import qs.modules.pill.behaviors

/*Variants {
    model: Quickshell.screens
    PanelWindow {
        id: bar
        required property var modelData
        screen: modelData

        anchors {
            top: true
            left: true
            right: true
        }
        color: "transparent"
        implicitHeight: barRow.implicitHeight + Config.barMarginV * 2
        RowLayout {
            id: barRow
            anchors.fill: parent
            anchors.topMargin: Config.barMarginV
            anchors.leftMargin: Config.barMarginH
            anchors.rightMargin: Config.barMarginH
            spacing: 0

            Workspaces {}

            Item {
                Layout.fillWidth: true
            }

            Volume {}

            Item {
                Layout.margins: Config.widgetSpacing
            }
            Battery {}

            Item {
                Layout.margins: Config.widgetSpacing
            }

            Tray {}

            Item {
                Layout.margins: Config.widgetSpacing
            }
            
            NotifButton {}
        }
        Clock {
            id: clock
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                visible: Config.showClock
                z: 1
            
            }
    }
    
} */

Variants {
    model: Quickshell.screens
    PanelWindow {
        id: bar
        required property var modelData
        screen: modelData

        anchors {
            top: true
            left: true
            right: true
        }

        margins {
            top: Config.barMarginV
        }

        color: "transparent"
        implicitHeight: Config.barHeight + Config.barMarginV * 2

        MorphPill {
            id: morph
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
        }

        VolumeBehavior {}
        WorkspacesBehavior {}
    }

}