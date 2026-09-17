pragma Singleton

import QtQuick
import Quickshell
import qs.services

Singleton {
    id: root
    readonly property bool active: States.oled
    property url icon: active ? Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/oled/active.svg")) : Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/oled/inactive.svg"))

    function toggle() {
        States.oled = !States.oled;
        Wallpapers.reapply();
    }
}