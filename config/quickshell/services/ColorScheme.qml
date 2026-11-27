pragma Singleton

import QtQuick
import Quickshell
import qs.services

Singleton {
    id: root

    // Keep this as a reactive block so the icon always tracks the loaded scheme.
    readonly property url icon: {
        const scheme = States.ready ? States.colorScheme : "dark";
        if (scheme === "oled")
            return Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/lightdarkmode/oled.svg"));
        if (scheme === "light")
            return Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/lightdarkmode/lightmode.svg"));
        return Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/lightdarkmode/darkmode.svg"));
    }

    readonly property string colorScheme: States.colorScheme

    function cycleNext() {
        if (!States.ready)
            return;
        if (root.colorScheme === "oled")
            States.colorScheme = "light";
        else if (root.colorScheme === "light")
            States.colorScheme = "dark";
        else
            States.colorScheme = "oled";
    }

    // Wait until States has loaded from disk so we don't reapply matugen
    // with the JsonAdapter default on every qs reload.
    onColorSchemeChanged: {
        if (States.ready)
            Wallpapers.reapply();
    }

    function setScheme(scheme) {
        if (!States.ready)
            return;
        States.colorScheme = scheme;
        Wallpapers.reapply();
    }
}
