// Bar.qml
import Quickshell
import QtQuick.Layouts
import QtQuick

Scope {

  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: bar	    
      required property var modelData
      screen: modelData
      color: "Transparent" 

      anchors {
        top: true
        bottom: true
        right: true
      }

      Rectangle {
	      anchors.fill: parent
	      color: '#806474ff'
	      topLeftRadius: 16
	      bottomLeftRadius: 16
	      border.color: "#b32033dc"
	      border.width: 1
      }

      implicitWidth: 30
      ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter 
        spacing: 8

        ClockWidget { }
        Networking { barWindow: bar }
      } 	
     
    }
  }
}
