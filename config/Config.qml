pragma Singleton
import Quickshell
import qs.services

Singleton {
    // Timing
    readonly property int animMs: Gamemode.active ? 0 : 300
    readonly property int ttlMs: 1500
    readonly property int holdMs: 200

    // Spacing scale
    readonly property int spaceXs: 2
    readonly property int spaceSm: 5
    readonly property int spaceMd: 10
    readonly property int spaceLg: 16
    readonly property int spaceXl: 20

    // Bar
    readonly property int barHeight: 36
    readonly property int barMarginH: Gamemode.active ? 0 : 14
    readonly property int barMarginV: Gamemode.active ? 0 : spaceMd
    readonly property int barItemGap: spaceXs
    readonly property int barVerticalPadding: barMarginV * 2

    // Control Panel
    readonly property int controlPanelW: 600
    readonly property int controlPanelH: 500
    readonly property int controlPanelPadding: spaceMd
    readonly property int controlPanelHeaderHeight: 40
    readonly property int controlPanelHeaderInset: spaceMd
    readonly property int controlPanelBodyTopGap: 12
    readonly property int controlPanelFooterInset: spaceMd
    readonly property int controlPanelFooterBottomInset: spaceMd
    readonly property int controlPanelStatsSpacing: spaceLg

    // Clock
    readonly property string clockFormat: "h:mm AP"
    readonly property string dateFormat: "MMM, dd"

    // Workspaces
    readonly property int workspaceCount: 5
    readonly property int workspaceSpacing: 7
    readonly property int workspacePadH: 18
    readonly property real workspaceItemGap: widgetSpacing / 3
    readonly property real workspaceCollapsedExtraWidth: workspacePadH * 1.5
    readonly property real workspaceExpandedExtraWidth: workspacePadH * 3
    
    // Bar Widgets (Volume, Battery, etc.)
    readonly property int widgetSpacing: spaceXs
    readonly property int moduleGap: widgetSpacing * 2
    readonly property int trayIconSize: 16
    readonly property int borderWidth: 1
    readonly property int radiusPill: Gamemode.active ? 0 : 12
    readonly property int radiusBox: Gamemode.active ? 0 : 8
    readonly property double volumeStep: 0.05
    readonly property int volumeMin: 0
    readonly property int volumeMax: 1

    // HoverTip
    readonly property int hoverTipPadH: 10
    readonly property int hoverTipPadV: 5

    readonly property int pillPadH: spaceMd
    readonly property int pillPadV: spaceSm
    readonly property real pillFaceWidthScale: 1.5

    // Session menu
    readonly property int sessionMenuPadding: spaceMd
    readonly property int sessionMenuEntrySpacing: spaceXs

    // Feature Toggles
    readonly property bool showClock: true

    // Icon Sized
    readonly property int iconSize: 30
}
