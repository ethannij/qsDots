pragma Singleton

import QtQuick
import qs.services
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

Singleton {
    id: root

    signal gammaChangeAttempt

    readonly property real gammaLowerLimit: 25
    readonly property real gammaUpperLimit: 100

    property int defaultColorTemperature: 6500
    property int nightColorTemperature: 4500
    property int gamma: 100
    property int gammaRestore: 100
    property int gammaStep: 5
    property bool firstEvaluation: true
    property bool temperatureActive: false
    property string temperatureState: "auto"

    property int hour: Time.date.getHours()

    // Debug hour cycler to test automatic behavior
    /*property int hour: 0
    property int hourOld: 0

    Timer {
        id: testingTimer
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            hourOld = hour
            hour = hourOld + 1
            if (hour > 24)
                hour = 0;
            console.log("hour: " + hour)
        }
    }
    */
    property int fromHour: 21
    property int toHour: 9

    property bool isNight: hour >= fromHour || hour <= toHour

    // switch to case statements
    property url brightnessIconURL: {
        if (gamma <= 25)
            return Qt.resolvedUrl("../modules/img/brightness/brightness_1.svg");
        if (gamma <= 33)
            return Qt.resolvedUrl("../modules/img/brightness/brightness_2.svg");
        if (gamma <= 45)
            return Qt.resolvedUrl("../modules/img/brightness/brightness_3.svg");
        if (gamma <= 60)
            return Qt.resolvedUrl("../modules/img/brightness/brightness_4.svg");
        if (gamma <= 75)
            return Qt.resolvedUrl("../modules/img/brightness/brightness_5.svg");
        if (gamma <= 90)
            return Qt.resolvedUrl("../modules/img/brightness/brightness_6.svg");
        return Qt.resolvedUrl("../modules/img/brightness/brightness_7.svg");
    }

    property list<url> temperatureIconURLs: [Qt.resolvedUrl("../modules/img/colorTemp/colTemp_off.svg"), Qt.resolvedUrl("../modules/img/colorTemp/colTemp_on.svg"), Qt.resolvedUrl("../modules/img/colorTemp/colTemp_auto.svg")]

    property url activeTemperatureIconURL: {
        if (temperatureState === "off")
            return root.temperatureIconURLs[0];
        if (temperatureState === "on")
            return root.temperatureIconURLs[1];
        return root.temperatureIconURLs[2];
    }

    function startHyprsunset() {
        Quickshell.execDetached(["bash", "-c", `pidof hyprsunset || hyprsunset`]);
    }

    function enableTemperature() {
        root.temperatureActive = true;
        root.temperatureState = "on";
        root.startHyprsunset();
        Quickshell.execDetached(["bash", "-c", `hyprctl hyprsunset temperature ${root.nightColorTemperature}`]); // TODO: make this dynamic
    }

    function disableTemperature() {
        root.temperatureActive = false;
        root.temperatureState = "off";
        root.startHyprsunset();
        Quickshell.execDetached(["bash", "-c", `hyprctl hyprsunset temperature ${root.defaultColorTemperature}`]); // TODO: make this dynamic
    }

    function automaticTemperature() {
        root.temperatureState = "auto";
        root.evaluateTemperature();
    }

    function evaluateTemperature() {
        if (root.isNight && root.temperatureState === "auto") {
            Quickshell.execDetached(["bash", "-c", `hyprctl hyprsunset temperature ${root.nightColorTemperature}`]);
        } else if (!root.isNight || root.temperatureState === "auto") {
            Quickshell.execDetached(["bash", "-c", `hyprctl hyprsunset temperature ${root.defaultColorTemperature}`]);
        }
    }

    function temperatureNext() {
        if (root.temperatureState === "off")
            enableTemperature();
        else if (root.temperatureState === "on")
            automaticTemperature();
        else if (root.temperatureState === "auto")
            disableTemperature();
    }

    onTemperatureStateChanged: {
        if (root.temperatureState === "off")
            disableTemperature();
        if (root.temperatureState === "on")
            enableTemperature();
        if (root.temperatureState === "auto")
            evaluateTemperature();
    }

    onHourChanged: {
        root.evaluateTemperature();
    }

    function setGamma(gamma) {
        root.gamma = Math.max(root.gammaLowerLimit, Math.min(root.gammaUpperLimit, gamma));
        root.gammaChangeAttempt();

        root.startHyprsunset();
        Quickshell.execDetached(["bash", "-c", `hyprctl hyprsunset gamma ${root.gamma}`]);
    }
    function gammaUp() {
        root.setGamma(root.gamma + root.gammaStep);
    }

    function gammaDown() {
        root.setGamma(root.gamma - root.gammaStep);
    }

    IpcHandler {
        id: ipc
        target: "hyprsunsetIpc"
        function screenDim(): void {
            root.gammaRestore = root.gamma
            root.setGamma(40);

        }
        function screenBright(): void {
            root.setGamma(root.gammaRestore);
        }
        function increaseGamma(): void {
            root.gammaUp();
        }
        function decreaseGamma(): void {
            root.gammaDown();
        }
    }
}
