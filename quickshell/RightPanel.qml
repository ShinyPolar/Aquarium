// RightPanel.qml
import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Scope {

  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: rightPanel
      required property var modelData
      screen: modelData

      exclusionMode: ExclusionMode.Ignore

      anchors {
        top: true
        right: true
        bottom: true
      }

      // TODO: width, margins.top, visible
      visible: Global.expanded
      implicitWidth: 600

      Rectangle {
        anchors.fill: parent
        color: "#1e1e2e"  // placeholder, swap for your Arknights palette later
	}
	ColumnLayout {
	  id: topStack
	  anchors.top: parent.top
	  anchors.left: parent.left
	  anchors.right: parent.right
	  anchors.margins: 12
	  spacing: 12
	
	  RowLayout {
	    Button { text: "Wifi"; onClicked: Global.request("wifi") }
	    Button { text: "Bluetooth"; onClicked: Global.request("bluetooth") }
	    Button { text: "Volume"; onClicked: Global.request("volume") }
	  }
	
	  RowLayout {
	    // next row, e.g. workspace chips later
	  }
	
	  RowLayout {
	    // third row
	  }
	}
	
	Loader {
	  anchors.top: parent.verticalCenter
	  anchors.bottom: parent.bottom
	  anchors.left: parent.left
	  anchors.right: parent.right
	  anchors.margins: 12
	  sourceComponent: { 
   	    if (Global.activePanel === "wifi") return wifiStub
   	    if (Global.activePanel === "bluetooth") return btStub
   	    if (Global.activePanel === "volume") return volumeStub
   	    return notifStub }
	}
	Component {
	  id: wifiStub
	  Rectangle { color: "#1d9e75"; Text { anchors.centerIn: parent; text: "wifi stub" } }
	}
	Component {
	  id: btStub
	  Rectangle { color: "#378add"; Text { anchors.centerIn: parent; text: "bluetooth stub" } }
	}
	Component {
	  id: volumeStub
	  Rectangle { color: "#d85a30"; Text { anchors.centerIn: parent; text: "volume stub" } }
	}
	Component {
	  id: notifStub
	  Rectangle { color: "#5f5e5a"; Text { anchors.centerIn: parent; text: "notifications (default)" } }
	}


    }
  }
}
