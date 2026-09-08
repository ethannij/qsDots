//@ pragma UseQApplication
import Quickshell
import QtQuick
import qs.modules
import qs.services
import qs.modules.windows

ShellRoot {
    id: root
    ControlBar {}

    Component.onCompleted: {
        
for (const d of Power.devices) {
    console.log(d.nativePath, d.type, d.model, d.percentage, d.isLaptopBattery, d.powerSupply)
}    }
}
