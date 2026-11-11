import Quickshell
import QtQuick
import QtQuick.Controls
import qs.config
import qs.theme
import qs.modules.elements

PillShape {
    id: root
    interactive: false
    color: Colors.md3.surface_variant

    signal accepted()
    property alias text: textInput.text
    property bool intOnly: false
    clip: true

    TextInput {
        id: textInput
        text: root.text
        font: StylizedFont.body
        width: Math.max(24, contentWidth)
        horizontalAlignment: TextInput.AlignHCenter
        verticalAlignment: TextInput.AlignVCenter
        color: Colors.md3.on_surface
        inputMethodHints: parent.intOnly ? Qt.ImhDigitsOnly : Qt.ImhNone
        activeFocusOnPress: true
        focus: false

        Keys.onEscapePressed: {
            focus = false;
        }

        onAccepted: {
            root.accepted();
        }
    }

    // Animations for prompt
    Behavior on opacity {
        NumberAnimation {
            duration: Config.animMs
            easing.type: Easing.InOutBack
        }
    }

    Behavior on implicitWidth {
        NumberAnimation {
            duration: Config.animMs
            easing.type: Easing.InOutBack
        }
    }
}
