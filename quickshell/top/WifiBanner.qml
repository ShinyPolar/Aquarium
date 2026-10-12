import QtQuick
import QtQuick.Shapes
import ".."

Item {
  id: root
  implicitHeight: 70
  property color accent: Theme.accent
  property string panelName: "wifi"
  property color sandColor: "#c9b48a"



  //box
  Item {
    id: body
    width: parent.width
    height: parent.height
    Rectangle {
      width: parent.width
      height: parent.height
      color: "#40000000"
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
      color: root.sandColor
    
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
      text: "WIFI"
      x: 5
      color: "#F88379"
      font.pointSize: 32
    }
  }

  }
  HoverHandler { id: hover }
  TapHandler {
    enabled: !root.blocked
    onTapped: Global.request(root.panelName)
  }
}
