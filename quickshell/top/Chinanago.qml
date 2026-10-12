// Chinanago.qml  -- procedural spotted garden eel (FR-08 / FR-09)
//   extend      0..1  how far it pokes out of the sand (map to signal strength)
//   highlighted       connected / selected network
//   animate           sway on/off (turn off when the panel is closed)
import QtQuick
import QtQuick.Shapes
import ".."

Item {
  id: root
  implicitWidth: 30
  implicitHeight: 60

  property real extend: 1.0
  property real offsetX: 0
  property bool highlighted: false
  property bool animate: true
  property real thickness: 7
  property color bodyColor: "#f2efe6"
  property color spotColor: "#2b2b2b"
  
  readonly property real baseX: width / 2
  readonly property real baseY: height
  readonly property real len: (height - thickness) * 0.8//(0.1 + 0.9 * extend)
  // comment out for nwo, will have to do hiding animation for mouse cursor position
  //Behavior on movementX { NumberAnimation { duration: 500; easing.type: Easing.OutCubic } }
  SequentialAnimation on offsetX {
  loops: Animation.Infinite
  running: root.animate
  NumberAnimation { from: 5; to: 0;  duration: 2000; easing.type: Easing.InOutQuad }
  NumberAnimation { from: 0;  to: 5; duration: 2000; easing.type: Easing.InOutCubic }
  }

  //for body animation
  readonly property real tipX: baseX + 3 + 3 * offsetX
  readonly property real tipY: baseY - len
  readonly property real ctrlX: baseX - 3 +  2 * offsetX
  readonly property real ctrlY: baseY - len * 0.8


  // Point on the body curve at t (0 = sand, 1 = head).
  function pt(t) {
    const u = 1 - t;
    return {
      x: u * u * baseX + 2 * u * t * ctrlX + t * t * tipX,
      y: u * u * (baseY + 4) + 2 * u * t * ctrlY + t * t * tipY
    };
  }

 // body
 Shape {
   anchors.fill: parent
   preferredRendererType: Shape.CurveRenderer
   ShapePath {
     strokeColor: root.highlighted ? Theme.accent : root.bodyColor
     strokeWidth: root.thickness
     capStyle: ShapePath.RoundCap
     fillColor: "transparent"
     startX: root.baseX
     startY: root.baseY + 4
     PathQuad {
       controlX: root.ctrlX; controlY: root.ctrlY
       x: root.tipX;         y: root.tipY
     }
   }
 }

 // spots
 Repeater {
   model: 3
   Rectangle {
     required property int index
     readonly property var p: root.pt(0.15 + index * 0.33)
     width: root.thickness * 0.6
     height: width
     radius: width / 2
     x: p.x - width / 2 + (index % 2 ? 1 : -1)
     y: p.y - height / 2
     color: root.spotColor
   }
     
  }

      Rectangle {
     width: 2.5; height: 2.5; radius: 1.25
     color: "black"
     x: root.tipX
     y: root.tipY
    }
//  Rectangle {
//    width: root.thickness * 1.2
//    height: width
//    radius: width / 2
//    x: root.tipX - width / 2
//    y: root.tipY - height / 2
//    color: root.highlighted ? Theme.accent : root.bodyColor
//    Rectangle {
//      width: 2.5; height: 2.5; radius: 1.25
//      color: "black"
//      x: parent.width / 2 - 1.25 + (root.sway >= 0 ? 1.5 : -1.5)
//      y: parent.height / 2 - 2
//    }
//  }

}

