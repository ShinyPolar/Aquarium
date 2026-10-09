// RightPanel.qml
import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "sections"
import "top"
import "services"

Scope {

  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: rightPanel
      required property var modelData
      screen: modelData
      focusable: true

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
	  SanityCircle { Layout.alignment: Qt.AlignTop }

 	 ColumnLayout {
 	   Layout.fillWidth: true
 	   Layout.alignment: Qt.AlignTop
 	   spacing: 10

 	   EventBanner {
 	     Layout.fillWidth: true
 	     panelName: "wifi"
 	     title: "WI-FI"
 	     subtitle: !WifiService.enabled  ? "Radio off"
 	             : WifiService.connected ? WifiService.activeName
 	             :                         "No network"
 	     status: !WifiService.enabled  ? "CLOSED"
 	           : WifiService.connected ? "ONLINE " + Math.round(WifiService.activeSignal * 100) + "%"
 	           :                         "STANDBY"
 	     live: WifiService.connected
 	   }

 	   EventBanner {
 	     Layout.fillWidth: true
 	     panelName: "bluetooth"
 	     title: "BLUETOOTH"
 	     accent: Theme.accentAlt
 	     subtitle: !BluetoothService.available    ? "No adapter"
 	             : !BluetoothService.powered      ? "Radio off"
 	             : BluetoothService.hasConnection ? BluetoothService.connectedDevices.map(d => d.name).join(", ")
 	             :                                  "No devices linked"
 	     status: !BluetoothService.powered      ? "CLOSED"
 	           : BluetoothService.hasConnection ? "LINKED"
 	           :                                  "STANDBY"
 	     live: BluetoothService.hasConnection
 	   }

 	 }
	  }
	
	  RowLayout {
	    // next row, e.g. workspace chips later
	  }
	
	  RowLayout {
		  // third row
  		  EventBanner {   // placeholder until the audio service exists
  		    Layout.fillWidth: true
  		    panelName: "volume"
  		    title: "MIXER"
  		    subtitle: "Volume control"
  		    status: "SOON"
  		  }
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
          WifiSection {}
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
