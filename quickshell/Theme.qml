pragma Singleton
import QtQuick
import Quickshell

// Colors are Qt #AARRGGBB (alpha FIRST).
Singleton {
  readonly property color panel:   "#cc1c1d22"
  readonly property color panelHi: "#e62a2c33"
  readonly property color line:    "#55ffffff"
  readonly property color track:   "#33ffffff"
  readonly property color text:    "#f2f2f2"
  readonly property color textDim: "#9aa0a6"
  readonly property color accent:    "#2ec4d6"   // aquarium teal
  readonly property color accentAlt: "#ffd23f"   // Arknights hazard yellow
  readonly property color good: "#40c88a"
  readonly property color warn: "#f5a742"
  readonly property color bad:  "#e64553"
  // Qt falls back to a default font if these aren't installed.
  readonly property string fontDisplay: "Bender"
  readonly property string fontBody: "Noto Sans"
}

