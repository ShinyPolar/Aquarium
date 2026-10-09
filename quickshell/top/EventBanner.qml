import QtQuick
import QtQuick.Shapes
import ".."

Item {
  id: root

  property string panelName: ""
  property string tag: "EVENT"
  property string title: ""
  property string subtitle: ""
  property string status: ""
  property bool live: false
  property color accent: Theme.accent

  readonly property bool active: Global.expanded && Global.activePanel === panelName
  readonly property bool blocked: Global.locked && Global.activePanel !== panelName
  readonly property real cut: 16

  implicitHeight: 70
  opacity: blocked ? 0.35 : 1
  Behavior on opacity { NumberAnimation { duration: 150 } }

  Item {
    id: body
    width: parent.width
    height: parent.height
    x: hover.hovered && !root.blocked ? -6 : 0
    Behavior on x { NumberAnimation { duration: 120; easing.type: Easing.OutQuad } }

    Shape {   // card with cut top-right corner
      anchors.fill: parent
      preferredRendererType: Shape.CurveRenderer
      ShapePath {
        fillColor: root.active ? Theme.panelHi : Theme.panel
        strokeColor: root.active ? root.accent : Theme.line
        strokeWidth: 1
        startX: 0; startY: 0
        PathLine { x: body.width - root.cut; y: 0 }
        PathLine { x: body.width; y: root.cut }
        PathLine { x: body.width; y: body.height }
        PathLine { x: 0; y: body.height }
        PathLine { x: 0; y: 0 }
      }
    }

    Rectangle {   // accent bar
      width: 4; height: parent.height
      color: root.accent
      opacity: root.active ? 1 : 0.6
    }

    Item {        // hazard stripes
      anchors.right: parent.right
      anchors.rightMargin: root.cut
      width: 70; height: parent.height
      clip: true
      opacity: root.active ? 0.25 : 0.12
      Repeater {
        model: 12
        Rectangle {
          required property int index
          width: 6; height: body.height * 2
          x: index * 12 - 30
          y: -body.height / 2
          rotation: 30
          color: root.accent
        }
      }
    }

    Rectangle {   // EVENT tag
      x: 14; y: 8
      width: tagText.implicitWidth + 10
      height: tagText.implicitHeight + 2
      color: root.accent
      Text {
        id: tagText
        anchors.centerIn: parent
        text: root.tag
        color: "#101114"
        font.family: Theme.fontDisplay
        font.pixelSize: 9
        font.bold: true
        font.letterSpacing: 1.5
      }
    }

    Column {      // title + subtitle
      x: 14
      anchors.bottom: parent.bottom
      anchors.bottomMargin: 8
      width: parent.width - 28 - root.cut
      Text {
        width: parent.width
        elide: Text.ElideRight
        text: root.title
        color: Theme.text
        font.family: Theme.fontDisplay
        font.pixelSize: 20
        font.bold: true
        font.letterSpacing: 2
      }
      Text {
        width: parent.width
        elide: Text.ElideRight
        text: root.subtitle
        color: Theme.textDim
        font.family: Theme.fontBody
        font.pixelSize: 10
      }
    }

    Row {         // status
      anchors.right: parent.right
      anchors.rightMargin: root.cut + 6
      y: 9
      spacing: 5
      Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        width: 6; height: 6; radius: 3
        color: root.live ? Theme.good : Theme.textDim
      }
      Text {
        text: root.status
        color: root.live ? Theme.text : Theme.textDim
        font.family: Theme.fontDisplay
        font.pixelSize: 9
        font.bold: true
        font.letterSpacing: 1.5
      }
    }
  }

  HoverHandler { id: hover }
  TapHandler {
    enabled: !root.blocked
    onTapped: Global.request(root.panelName)
  }
}

