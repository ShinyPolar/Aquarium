// Bar.qml
import Quickshell
import QtQuick.Layouts
import QtQuick
import "widgets"

Scope {

  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: bar	    
      required property var modelData
      screen: modelData
      color: "transparent" 

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
	anchors.top: parent.top
	anchors.topMargin: 8

        ClockWidget 	{Layout.alignment: Qt.AlignHCenter }
	DateWidget 	{Layout.alignment: Qt.AlignHCenter }
	WifiIndicator	{Layout.alignment: Qt.AlignHCenter }
	BluetoothIndicator {Layout.alignment: Qt.AlignHCenter}
	BatteryIndicator { Layout.alignment: Qt.AlignHCenter}
       } 	
     
    }
  }
}
