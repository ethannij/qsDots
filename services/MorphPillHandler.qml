pragma Singleton
import qs.modules.bar
import Quickshell
import QtQuick


// Control which face is active in pill
Singleton {
    id: handler

    property string activeFace: "clock"
    property string defaultFace: "clock"


}