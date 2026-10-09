// WifiWidget.qml  (UI layer -- placeholder visuals, becomes the chinanago later)
import QtQuick
import Quickshell
import Quickshell.Networking   // for WifiSecurityType enum when you add PSK prompts
import "services"            // adjust path to wherever WifiService lives

Item {
  id: root

  implicitWidth: icon.implicitWidth
  implicitHeight: icon.implicitHeight

  property bool expanded: false

  // Enable scanning only while the popup is open (saves power/CPU).
  onExpandedChanged: WifiService.setScanning(expanded)

  Text {
    id: icon
    text: WifiService.connected ? "📶" : "📵"  // placeholder; swap for chinanago/glyph
  }

  // Single shared close delay. ANY hover cancels it; losing hover restarts it.
  Timer {
    id: closeTimer
    interval: 350
    onTriggered: root.expanded = false
  }

  HoverHandler {
    id: iconHover
    onHoveredChanged: {
      if (hovered) { closeTimer.stop(); root.expanded = true; }
      else closeTimer.restart();
    }
  }

  PopupWindow {
    id: panel
    anchor.item: root
    anchor.rect.x: -120
    anchor.rect.y: root.height
    implicitWidth: 240
    implicitHeight: 200
    visible: root.expanded

    Rectangle {
      anchors.fill: parent
      color: "#1e1e2e"   // placeholder palette

      ListView {
        anchors.fill: parent
        anchors.margins: 8
        clip: true
        model: WifiService.networks   // ObjectModel<WifiNetwork>

        delegate: Text {
          required property var modelData
          color: modelData.connected ? "#a6e3a1" : "white"
          text: modelData.name
                + (modelData.connected ? "  ✓" : "")
                + "  " + Math.round(modelData.signalStrength * 100) + "%"

          MouseArea {
            anchors.fill: parent
            onClicked: WifiService.connect(modelData)
          }
        }
      }

      // Keep the panel open while the pointer is inside it.
      HoverHandler {
        onHoveredChanged: {
          if (hovered) closeTimer.stop();
          else closeTimer.restart();
        }
      }
    }
  }
}

