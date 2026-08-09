pragma Singleton
import Quickshell
import QtQuick
Singleton {
    // Bar
    readonly property int barHeight: 36
    readonly property int barMarginH: 14
    readonly property int barMarginV: 10
    readonly property int barItemGap: 2
    readonly property int ttlMs: 1500
    readonly property int holdMs: 200

    // Font/Typography
    readonly property string fontFamilyPropo: "JetBrainsMono Nerd Font Propo"
    readonly property string fontFamilyMono: "JetBrainsMono Nerd Font Mono"
    readonly property int fontSize: 14
    readonly property int fontSizeIcon: 16
    readonly property int fontSizeLabel: 16
    readonly property int fontSizeTip: 10
    readonly property string fontWeightBold: "1000"
    readonly property string fontWeight: "400"

    // Clock
    readonly property string clockFormat: "h:mm AP"
    readonly property string dateFormat: "MMM, dd"

    // Workspaces
    readonly property int workspaceCount: 5
    readonly property int workspaceSpacing: 7
    readonly property int workspacePadH: 18
    readonly property int animMs: 300

    // Bar Widgets (Volume, Battery, etc.)
    readonly property int widgetSpacing: 2
    readonly property int moduleGap: widgetSpacing * 2
    readonly property int borderWidth: 1
    readonly property int radiusPill: 50
    readonly property int radiusBox: 8
    readonly property double volumeStep: 0.05
    readonly property int volumeMin: 0
    readonly property int volumeMax: 1

    // HoverTip
    readonly property int hoverTipPadH: 10
    readonly property int hoverTipPadV: 5

    readonly property int pillPadH: 10
    readonly property int pillPadV: 5

    // Feature Toggles
    readonly property bool showVolume: true
    readonly property bool showBattery: true
    readonly property bool showClock: true
}
