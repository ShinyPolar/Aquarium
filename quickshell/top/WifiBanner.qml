import QtQuick
import QtQuick.Shapes
import ".."

Item {
  id: root
  implicitHeight: 70
  property color accent: Theme.accent
  property string panelName: "wifi"
  property color sandColor: "#c9b48a"
  property color sandDColor: '#a78e5e'
  property color waterColor: "#18A6C7"
  property color waterDColor: "#14859f"



  //box
  Item {
    id: body
    width: parent.width
    height: parent.height
    Rectangle {
      width: parent.width
      height: parent.height
      color: "black"
      opacity: 0.7
      border.color: root.accent
      border.width: 1

      //sand
      Rectangle {
        height: 20
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottomMargin: 1
        anchors.leftMargin: 1
        anchors.rightMargin: 1
        gradient: Gradient {
          GradientStop { position: 1.0; color: root.sandColor }
          GradientStop { position: 0.0; color: root.sandDColor }
        }
      }
      //water
      Rectangle {
        height: parent.height - 20
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: 1
        anchors.leftMargin: 1
        anchors.rightMargin: 1
        gradient: Gradient {
          GradientStop { position: 0.0; color: root.waterColor }
          GradientStop { position: 1.0; color: root.waterDColor }
        }
      }
      
      // Chinanago
      Chinanago {
      //width: 40; height: 40
      x: 150
      extend: modelData.signalStrength     // pokes out further on strong signal
      highlighted: modelData.connected
      animate: Global.expanded             // freeze when the panel is closed
      }

      Chinanago {
      //width: 40; height: 40
      x:170
      extend: modelData.signalStrength     // pokes out further on strong signal
      highlighted: modelData.connected
      animate: Global.expanded             // freeze when the panel is closed
      }   

      Chinanago {
      //width: 40; height: 40
      x: 190
      extend: modelData.signalStrength     // pokes out further on strong signal
      highlighted: modelData.connected
      animate: Global.expanded             // freeze when the panel is closed
      }



      Text {
        text: "W F"
        x: 5
        y: 0
        color: "#F88379"
        font.pointSize: 48
        font.family: "Coral Reef"
      }

      Image {
        source: "../assets/coral01.svg"
        x: 50
        y: 5
        width: 48
        height: 58
      }

      Image {
        source: "../assets/coral01.svg"
        x: 106
        y: 5
        width: 48
        height: 58
      }

      Image {
        source: "../assets/coral03.svg"
        x: 3
        y: 30
        width: 30
        height: 30
      }

      Image {
        source: "../assets/coral04.svg"
        x: 260
        y: 18
        width: 50
        height: 50
      }

      Image {
        source: "../assets/coral06.svg"
        x: 42
        y: 38
        width: 30
        height: 30
      }
      
  }

  }
  HoverHandler { id: hover }
  TapHandler {
    enabled: !root.blocked
    onTapped: Global.request(root.panelName)
  }
}
