//@ pragma UseQApplication

import QtQuick
import Quickshell
import QtQuick.Controls
import QtQuick.Effects
import qs.modules
import qs.modules.screenlock
import qs.modules.windows
import qs.modules.elements
import qs.services
import qs.config
import qs.theme

ShellRoot {
    id: root

    ControlBar {
        id: bar
        lockHeld: lock.locked && lock.covering
    }

    Lockscreen {
        id: lock
        barWidth: bar.pillWidth
        barHeight: bar.pillHeight
        clockShift: bar.clockShift
    }

    // Debug window
    Window {
        width: 500
        height: 500
        visible: false
        title: "testWindow"

        Rectangle {
            anchors.fill: parent
            color: Colors.md3.surface

            Item {
                id: ui_design_test
                anchors.fill: parent

                Rectangle {
                    id: foreground_rect
                    width: 300
                    height: 120
                    anchors.centerIn: parent
                    color: Colors.md3.on_surface
                    radius: height / 6
                    opacity: 0.5
                }

                Rectangle {
                    id: background_rect
                    anchors.fill: foreground_rect
                    color: Colors.md3.tertiary
                    radius: foreground_rect.radius
                    z: -1

                }

                MultiEffect {
                    anchors.fill: background_rect
                    source: background_rect
                    blurEnabled: true
                    blur: 1.0
                    brightness: 0.1
                }
            }

            Item {
                id: item
                anchors.fill: parent
                visible: false

                Image {
                    id: sourceItem
                    source: "/home/ethannij/.config/hypr/img/pibble.webp"
                    width: 500
                    height: 500
                    anchors.left: parent.left
                    layer.enabled: true
                    layer.effect: MultiEffect {
                        blurEnabled: true
                        blur: 1.0
                        blurMax: 32
                    }

                    Text {
                        anchors.centerIn: parent
                        font: StylizedFont.Title
                        text: "Layered"
                        color: Colors.md3.primary
                    }
                }

                Image {
                    id: effectItem
                    source: "/home/ethannij/.config/hypr/img/pibble.webp"
                    anchors.right: parent.right
                    width: 500
                    height: 500
                    Text {
                        anchors.centerIn: parent
                        font: StylizedFont.Title
                        text: "Effect"
                        color: Colors.md3.primary
                    }
                }
                MultiEffect {
                    anchors.fill: effectItem
                    source: effectItem
                    blurEnabled: true
                    blur: 1.0
                    blurMax: 32
                }
            }
        }
    }
}
