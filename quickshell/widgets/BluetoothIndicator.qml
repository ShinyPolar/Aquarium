// BluetoothIndicator.qml  (display-only, lives in the Bar)
// FR-16. PLACEHOLDER glyph -- plain ASCII so it renders in any font.
import QtQuick
import "../services"

Item {
  id: root
  implicitWidth: glyph.implicitWidth
  implicitHeight: glyph.implicitHeight

  // DEBUG: always visible for now. Once it works, change to:
  //   visible: BluetoothService.available
  Text {
    id: glyph
    anchors.centerIn: parent
    text: "B"
    font.bold: true

    // red = no adapter found, dim = off, medium = on/idle, bright = connected
    color: BluetoothService.available ? "white" : "#e64553"
    opacity: !BluetoothService.available    ? 0.8
           : !BluetoothService.powered      ? 0.3
           :  BluetoothService.hasConnection ? 1.0
           :                                   0.6

    Behavior on opacity { NumberAnimation { duration: 300 } }
  }
}

