pragma Singleton

import QtQuick
import Quickshell
import qs.services

Singleton {
    id: root

    property url icon: States.colorScheme === "oled" ? Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/lightdarkmode/oled.svg"))
        : States.colorScheme === "light" ? Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/lightdarkmode/lightmode.svg"))
        : Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/lightdarkmode/darkmode.svg"))

    readonly property string colorScheme: States.colorScheme

    function cycleNext() {
        if (root.colorScheme === "oled")
            States.colorScheme = "light";
        else if (root.colorScheme === "light")
            States.colorScheme = "dark";
        else
            States.colorScheme = "oled";
    }

    // Wait until States has loaded from disk so we don't reapply matugen
    // with the JsonAdapter default ("light") on every qs reload.
    onColorSchemeChanged: {
        if (States.ready)
            Wallpapers.reapply();
    }

    function setScheme(scheme) {
        States.colorScheme = scheme;
        if (States.ready)
            Wallpapers.reapply();
    }
}
