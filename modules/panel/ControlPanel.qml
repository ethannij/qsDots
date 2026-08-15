import QtQuick
import Quickshell
import qs.modules.elements
import qs.services
import Quickshell.Io
import qs.config
import qs.theme
import QtQuick.Layouts
import qs.modules.bar
import qs.modules.panel.modules

Item {
    id: root
    property alias chrome: controlPanel.chrome
  

    implicitWidth: controlPanel.implicitWidth
    implicitHeight: controlPanel.implicitHeight
    
    PillShape {
        id: controlPanel
        chrome: true
        implicitWidth: 600
        implicitHeight: 500
        anchors.centerIn: parent
        interactive: false


       
            width: 600
            height: 500
        
            Text {
                id: user

                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                text: Quickshell.env("USER")
                Layout.alignment: Qt.AlignLeft
                font {
                    family: Config.fontFamilyPropo
                    pointSize: Config.fontSize
                    weight: Config.fontWeight
                }
                color: Colors.md3.on_surface
            }
 


            Clock {
                chrome: false
                anchors.verticalCenter: parent.verticalCenter
            }


            Text {
                text: "󰐥"
                font.family: Config.fontFamilyPropo
                font.pointSize: Config.fontSize
                font.weight: Config.fontWeight
                color: Colors.md3.on_surface  
            }
        }
        

    IpcHandler {
        id: ipcPanel
        target: "ipcPanel"
        function toggleControlPanel(): void {
            if (PillController.activeFace === "controlpanel")
                PillController.forceDismiss()
            else
                PillController.showFace("controlpanel");
           }
    }
    
}