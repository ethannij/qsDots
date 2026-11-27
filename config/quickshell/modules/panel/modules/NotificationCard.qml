import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import qs.services
import qs.config
import qs.theme

Item {
    id: root
    property var notification: null

    readonly property string iconUrl: {
        const n = root.notification;
        if (!n)
            return "";
        if (n.image && n.image.length > 0)
            return n.image;
        if (n.appIcon && n.appIcon.length > 0) {
            if (n.appIcon.indexOf("/") !== -1 || n.appIcon.indexOf(":") !== -1)
                return n.appIcon;
            return Quickshell.iconPath(n.appIcon, true);
        }
        return "";
    }

    readonly property string appInitial: {
        const name = root.notification?.appName || "?";
        return name.length > 0 ? name.charAt(0).toUpperCase() : "?";
    }

    implicitHeight: card.implicitHeight

    Rectangle {
        id: card
        anchors.left: parent.left
        anchors.right: parent.right
        implicitHeight: content.implicitHeight + Config.spaceSm * 2
        radius: Config.radiusBox
        color: cardHover.hovered ? Colors.role.hover : Colors.role.chip

        Behavior on color {
            enabled: Config.animMs > 0
            ColorAnimation {
                duration: Config.animMs
                easing.type: Easing[Config.animEasingSmooth]
            }
        }

        HoverHandler {
            id: cardHover
        }

        RowLayout {
            id: content
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: Config.spaceSm
            spacing: Config.spaceSm

            Item {
                id: iconSlot
                Layout.preferredWidth: Config.barIconSize + Config.spaceSm
                Layout.preferredHeight: Config.barIconSize + Config.spaceSm
                Layout.alignment: Qt.AlignTop

                Rectangle {
                    anchors.fill: parent
                    radius: width / 2
                    color: Colors.role.raised
                    visible: icon.status !== Image.Ready
                }

                Text {
                    anchors.centerIn: parent
                    visible: icon.status !== Image.Ready
                    text: root.appInitial
                    font: StylizedFont.tooltip
                    color: Colors.role.muted
                }

                IconImage {
                    id: icon
                    anchors.fill: parent
                    source: root.iconUrl
                    visible: status === Image.Ready
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                spacing: Config.spaceXs

                RowLayout {
                    Layout.fillWidth: true
                    spacing: Config.spaceSm

                    Text {
                        Layout.fillWidth: true
                        text: root.notification?.appName || ""
                        elide: Text.ElideRight
                        font: StylizedFont.tooltip
                        color: Colors.role.muted
                        visible: text.length > 0
                    }

                    Text {
                        text: Notifications.formatArrival(root.notification)
                        font: StylizedFont.tooltip
                        color: Colors.role.muted
                        visible: text.length > 0
                    }

                    Text {
                        id: dismiss
                        text: "\u00D7"
                        font: StylizedFont.icon
                        color: dismissHover.hovered ? Colors.md3.error : Colors.role.muted

                        HoverHandler {
                            id: dismissHover
                            cursorShape: Qt.PointingHandCursor
                        }

                        TapHandler {
                            gesturePolicy: TapHandler.ReleaseWithinBounds
                            onTapped: {
                                if (root.notification)
                                    root.notification.dismiss();
                            }
                        }
                    }
                }

                Text {
                    Layout.fillWidth: true
                    text: root.notification?.summary || ""
                    wrapMode: Text.Wrap
                    maximumLineCount: 2
                    elide: Text.ElideRight
                    font: StylizedFont.bold
                    color: Colors.role.ink
                    visible: text.length > 0
                }

                Text {
                    Layout.fillWidth: true
                    text: root.notification?.body || ""
                    wrapMode: Text.Wrap
                    maximumLineCount: 2
                    elide: Text.ElideRight
                    font: StylizedFont.tooltip
                    color: Colors.role.muted
                    visible: text.length > 0
                }

                Flow {
                    Layout.fillWidth: true
                    spacing: Config.spaceXs
                    visible: root.notification && root.notification.actions.length > 0

                    Repeater {
                        model: root.notification?.actions ?? []

                        Rectangle {
                            id: actionBtn
                            required property var modelData
                            implicitWidth: actionLabel.implicitWidth + Config.spaceMd
                            implicitHeight: actionLabel.implicitHeight + Config.spaceXs * 2
                            radius: Config.radiusBox
                            color: actionHover.hovered ? Colors.role.accentFill : Colors.role.raised

                            Text {
                                id: actionLabel
                                anchors.centerIn: parent
                                text: actionBtn.modelData.text
                                font: StylizedFont.tooltip
                                color: actionHover.hovered ? Colors.role.accentOnFill : Colors.role.ink
                            }

                            HoverHandler {
                                id: actionHover
                                cursorShape: Qt.PointingHandCursor
                            }

                            TapHandler {
                                gesturePolicy: TapHandler.ReleaseWithinBounds
                                onTapped: actionBtn.modelData.invoke()
                            }
                        }
                    }
                }
            }
        }
    }
}
