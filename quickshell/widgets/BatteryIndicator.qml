// BatteryIndicator.qml  (display-only, lives in the Bar)
//
// FR-07: battery shown as a "fish tank with water". Display-only -- no input.
// This is a PLACEHOLDER: a bordered rect that fills from the bottom by
// PowerService.level. Swap the inner Rectangle for real tank/water/fish art later.
import QtQuick
import "../services"   // adjust path to where PowerService lives

Item {
  id: root

  // Tank footprint. Tune to your bar width (bar is 30px wide right now).
  implicitWidth: 22
  implicitHeight: 34

  // Only meaningful on a device with a real battery.
  visible: !PowerService.ready || PowerService.hasBattery

  // The glass tank outline.
  Rectangle {
    id: tank
    anchors.fill: parent
    color: "#55000000"
    radius: 4
    border.width: 1
    border.color: "#b32033dc"
    clip: true

    // The water. Height tracks the charge level; anchored to the bottom so
    // it drains downward. This is the one line that makes it "fill up".
    Rectangle {
      id: water
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      anchors.margins: 1
      radius: 3
      height: Math.max(0, (parent.height - 2) * PowerService.level)

      // Tint: distinct colours
      color: PowerService.critical ? "#e64553" // red
           : PowerService.low      ? "#f5a742" // orange
           : PowerService.full     ? "#40c88a" // green
           :                         "#4fc3f7" // aqua water

      // Smoothly animate level changes instead of snapping -- reads as water.
      Behavior on height { NumberAnimation { duration: 600; easing.type: Easing.InOutQuad } }
      Behavior on color  { ColorAnimation  { duration: 400 } }
    }
  // --- Readout: sibling of the tank, on top, explicit width, auto-shrinks ---
    Text {
      id: readout
      z: 2
      anchors.centerIn: parent
      width: root.width - 2
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
  
      text: !PowerService.ready ? "?"
          : (PowerService.charging ? "+" : "") + PowerService.percent
  
      color: "white"
      style: Text.Outline
      styleColor: "black"
      font.bold: true
      font.pixelSize: 11
      fontSizeMode: Text.HorizontalFit
      minimumPixelSize: 6
    }

  }
}

