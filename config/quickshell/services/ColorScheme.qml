pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs.services

/*Singleton {
    property string colorScheme: "oled"
    property url iconSource: colorScheme === "dark" ? Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/lightdarkmode/darkmode.svg")) 
        : colorScheme === "oled" ? Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/lightdarkmode/oledmode.svg")) 
        : Qt.resolvedUrl(Quickshell.shellPath("modules/img/widgets/lightdarkmode/lightmode.svg"))

        function cycleNext() {
            switch (colorScheme) {
                case "light": colorScheme = "oled"
                case "dark": colorScheme = "oled"
                case "oled": colorScheme = "light"
                default: colorScheme = "dark"
            }
        }
}*/


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
        if (root.colorScheme === "oled") {
            States.colorScheme = "light"
        } else if (root.colorScheme === "light") {
            States.colorScheme = "dark"
        } else {
            States.colorScheme = "oled"
        }
    }

    onColorSchemeChanged: {
        Wallpapers.reapply();
    }

    function setScheme(scheme) {
        States.colorScheme = scheme;
        Wallpapers.reapply();
    }
}