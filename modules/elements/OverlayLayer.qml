import QtQuick
import qs.services

// Overlay Element for Panels
Item {
    id: root

    // Required layer properties
    required property string name
    required property real morph
    required property real contentOpacity

    // Enabled when parent overlay is active
    readonly property bool active: PillController.overlay === name

    opacity: active ? contentOpacity : 0
    enabled: active && morph >= 0.85
    visible: opacity > 0
    z: 1

}