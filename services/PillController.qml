pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Hyprland

// Controller api for entire pill
Singleton {
    id: handler

    // Default properties for pill faces
    property string activeFace: "clock"
    property string defaultFace: "clock"
    property bool pinned: false

    // Panel Properties
    property bool panelOpen: false
    property bool trayOpen: false
    property string page: "home"
    property bool launcherOpen: false
    property bool sessionMenuOpen: false
    readonly property string overlay: panelOpen ? "panel" : launcherOpen ? "launcher" : "none"

    // Input handling for super key
    property bool superTap: false
    property bool superHold: false
    property double superPressedAt: 0

    // Keybinds
    Timer {
        id: holdTimer
        interval: 100
        onTriggered: {
            handler.superHold = true;
            PillController.showFace("workspaces");
        }
    }

    GlobalShortcut {
        id: launcherShortcut
        name: "launcher"
        description: "Toggle Launcher on Super Tap"

        onPressed: {
            handler.superTap = true;
            handler.superHold = false;
            handler.superPressedAt = Date.now();
            holdTimer.restart();
        }
        onReleased: {
            holdTimer.stop();
            if (!handler.superTap || handler.panelOpen || handler.superHold)
                return;
            handler.toggleLauncher();
        }
    }

    GlobalShortcut {
        name: "launcherInterrupt"
        onPressed: {
            if (!launcherShortcut.pressed)
                return;
            if (Date.now() - launcherShortcut.superPressedAt < 30)
                return;
            handler.superTap = false;
        }
    }

    // Functions for pill face control

    function showFace(name) {
        if (panelOpen || launcherOpen)
            return;

        if (name === "clock") {
            faceTimer.stop();
            activeFace = name;
            return;
        }
        activeFace = name;
        if (panelOpen || pinned || launcherOpen)
            faceTimer.stop();
        else
            faceTimer.restart();
    }

    function dismiss() {
        if (panelOpen || pinned || launcherOpen)
            return;

        activeFace = "clock";
        faceTimer.stop();
    }

    function forceDismiss() {
        faceTimer.stop();
        activeFace = "clock";
        panelOpen = false;
    }

    onPinnedChanged: {
        if (panelOpen || pinned || launcherOpen)
            faceTimer.stop();
        else if (activeFace !== defaultFace)
            faceTimer.restart();
    }

    Timer {
        id: faceTimer

        interval: 2000
        repeat: false
        onTriggered: {
            if (handler.panelOpen || handler.pinned)
                return;

            handler.dismiss();
        }
    }

    // Functions for overlay control

    function togglePanel() {
        if (panelOpen) {
            closePanel();
        } else {
            showPanel();
        }
    }

    function showPanel() {
        panelOpen = true;
        closeLauncher();
        faceTimer.stop();
    }

    function closePanel() {
        panelOpen = false;
        trayOpen = false;
        sessionMenuOpen = false;
        faceTimer.restart();
    }

    function showLauncher() {
        launcherOpen = true;
        faceTimer.stop();
    }

    function closeLauncher() {
        launcherOpen = false;
        faceTimer.restart();
    }

    function toggleLauncher() {
        if (launcherOpen) {
            closeLauncher();
        } else {
            showLauncher();
        }
    }

    function closeOverlay() {
        closePanel();
        closeLauncher();
    }
}
