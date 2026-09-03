pragma Singleton

import Quickshell
import QtQuick

Singleton {
    readonly property string proportionalFamily: "JetBrainsMono Nerd Font Propo"
    readonly property string monospaceFamily: "JetBrainsMono Nerd Font Mono"

    readonly property font body: Qt.font({
        family: proportionalFamily,
        pointSize: 14,
        weight: 400
    })

    readonly property font bold: Qt.font({
        family: proportionalFamily,
        pointSize: 14,
        weight: 1000
    })

    readonly property font icon: Qt.font({
        family: proportionalFamily,
        pointSize: 16,
        weight: 400
    })

    readonly property font label: Qt.font({
        family: proportionalFamily,
        pointSize: 16,
        weight: 400
    })

    readonly property font display: Qt.font({
        family: proportionalFamily,
        pointSize: 48,
        weight: 400
    })

    readonly property font title: Qt.font({
        family: proportionalFamily,
        pointSize: 24,
        weight: 400
    })

    readonly property font tooltip: Qt.font({
        family: proportionalFamily,
        pointSize: 10,
        weight: 400
    })
}
