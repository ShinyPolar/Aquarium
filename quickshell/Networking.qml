// Networking.qml
import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Networking

Item {
  id: root
  required property var barWindow

  implicitWidth: icon.implicitWidth
  implicitHeight: icon.implicitHeight

  // TODO: one shared property that means "should the panel be open"
  property bool expanded: false


  property var wifiDevice: {
  	for (const device of Networking.devices.values){
		if (device.type == DeviceType.Wifi)	return device;
	}
	return null;
  }

  onWifiDeviceChanged: if (wifiDevice) wifiDevice.scannerEnabled = true;


  Text {
    id: icon
    text: "📶"  // swap for your icon font's wifi glyph
  }

  Timer{
    id: hoverTimer
    interval: 1000
    onTriggered: expanded = false
  }

  HoverHandler {
    id: iconHover
    // TODO: when this hovers, what should happen to `expanded`?
	onHoveredChanged: {
		if (hovered) {
		hoverTimer.stop()
		root.expanded = true
	} else {
		hoverTimer.restart()
	}
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
      color: "#1e1e2e"

      ListView {
      	anchors.fill: parent
	anchors.margins: 8
	clip: true
	model: wifiDevice ? wifiDevice.networks : null

	delegate: Text {
		required property var modelData
		text:modelData.name + " " + modelData.state

		MouseArea {
			anchors.fill: parent
			onClicked: {modelData.connect()}
		}
	}
      }

      HoverHandler {
        id: panelHover
	onHoveredChanged: {
	if (hovered){
		hoverTimer.stop()
	} else {
		root.expanded = false
	}
	}
      }

      // your actual wifi list content goes here later
    }
  }
}
