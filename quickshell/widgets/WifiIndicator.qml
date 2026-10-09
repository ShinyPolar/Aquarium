// WifiIndicator.qml  (display-only, lives in the Bar)
import QtQuick
import "../services"   // adjust to where WifiService lives

// Pure status glyph. No HoverHandler, no MouseArea, no popup.
// Becomes the chinanago poking out of the sand (FR-08) later.
Text {
  id: root
  text: WifiService.connected ? "📶" : "📵"   // placeholder for chinanago art
  // optionally reflect signal strength later, e.g. how far the eel pokes out:
  // opacity: 0.4 + 0.6 * WifiService.activeSignal
}

