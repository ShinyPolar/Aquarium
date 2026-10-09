import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import Quickshell.Widgets
import "../services"
import ".."

ColumnLayout {
  id: root
  spacing: 6

  property real size: 200
  readonly property real artR: 58
  readonly property real ringR: artR + 10
  readonly property real ringW: 5
  readonly property real barBase: ringR + 8
  readonly property real barMax: size / 2 - barBase - 2

  // cava only while the panel is open AND music is playing
  readonly property bool wantBars: Global.expanded && MediaService.isPlaying
  property bool holding: false
  function syncBars() {
    if (wantBars && !holding)      { CavaService.acquire(); holding = true; }
    else if (!wantBars && holding) { CavaService.release(); holding = false; }
  }
  onWantBarsChanged: syncBars()
  Component.onCompleted: syncBars()
  Component.onDestruction: if (holding) CavaService.release()

  function fmt(s) {
    s = Math.max(0, Math.floor(s));
    return Math.floor(s / 60) + ":" + String(s % 60).padStart(2, "0");
  }

  Item {
    id: circle
    Layout.alignment: Qt.AlignHCenter
    implicitWidth: root.size
    implicitHeight: root.size

    // sound-wave bars
    Repeater {
      model: CavaService.barCount
      Item {
        required property int index
        x: circle.width / 2
        y: circle.height / 2
        rotation: index * 360 / CavaService.barCount
        Rectangle {
          readonly property real v: CavaService.values[parent.index] || 0
          width: 4
          height: 2 + v * root.barMax
          x: -width / 2
          y: -(root.barBase + height)
          radius: 2
          color: Theme.accent
          opacity: MediaService.isPlaying ? 0.35 + 0.65 * v : 0.15
        }
      }
    }

    // progress ring
    Shape {
      anchors.fill: parent
      preferredRendererType: Shape.CurveRenderer
      ShapePath {
        strokeColor: Theme.track; strokeWidth: root.ringW; fillColor: "transparent"
        PathAngleArc {
          centerX: circle.width / 2; centerY: circle.height / 2
          radiusX: root.ringR; radiusY: root.ringR
          startAngle: 0; sweepAngle: 360
        }
      }
      ShapePath {
        strokeColor: MediaService.hasActive ? Theme.accent : "transparent"
        strokeWidth: root.ringW; fillColor: "transparent"
        capStyle: ShapePath.RoundCap
        PathAngleArc {
          centerX: circle.width / 2; centerY: circle.height / 2
          radiusX: root.ringR; radiusY: root.ringR
          startAngle: -90
          sweepAngle: 360 * ringProgress.value
        }
      }
    }
    QtObject {   // smooths the once-a-second position updates
      id: ringProgress
      property real value: MediaService.progress
      Behavior on value {
        enabled: MediaService.isPlaying
        NumberAnimation { duration: 1000; easing.type: Easing.Linear }
      }
    }

    // album art ("pfp")
    ClippingRectangle {
      anchors.centerIn: parent
      width: root.artR * 2; height: root.artR * 2
      radius: root.artR
      color: Theme.panel

      Image {
        anchors.fill: parent
        source: MediaService.artUrl
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        visible: status === Image.Ready
        sourceSize.width: width
        sourceSize.height: height
      }
      Text {
        anchors.centerIn: parent
        visible: MediaService.artUrl === "" || !MediaService.hasActive
        text: MediaService.hasActive ? "♪" : "Wanna
play?"
        horizontalAlignment: Text.AlignHCenter
        color: Theme.textDim
        font.family: Theme.fontDisplay
        font.pixelSize: MediaService.hasActive ? 36 : 16
        font.bold: true
      }
      Rectangle {
        anchors.fill: parent
        visible: MediaService.hasActive && !MediaService.isPlaying
        color: "#99000000"
        Text {
          anchors.centerIn: parent
          text: "PAUSED"
          color: Theme.text
          font.family: Theme.fontDisplay
          font.letterSpacing: 2
          font.bold: true
        }
      }
    }

    TapHandler { onTapped: MediaService.playPause() }
  }

  // sanity-style time: "1:23 /3:45"
  Row {
    Layout.alignment: Qt.AlignHCenter
    visible: MediaService.hasActive
    spacing: 2
    Text {
      id: timeNow
      text: root.fmt(MediaService.position)
      color: Theme.text
      font.family: Theme.fontDisplay
      font.pixelSize: 22
      font.bold: true
    }
    Text {
      anchors.baseline: timeNow.baseline
      text: MediaService.length > 0 ? "/" + root.fmt(MediaService.length) : ""
      color: Theme.textDim
      font.family: Theme.fontDisplay
      font.pixelSize: 13
    }
  }

  Text {
    Layout.fillWidth: true
    Layout.maximumWidth: root.size + 40
    Layout.alignment: Qt.AlignHCenter
    horizontalAlignment: Text.AlignHCenter
    elide: Text.ElideRight
    text: MediaService.hasActive ? MediaService.title : "No operation in progress"
    color: Theme.text
    font.family: Theme.fontBody
    font.bold: true
  }
  Text {
    Layout.fillWidth: true
    Layout.maximumWidth: root.size + 40
    Layout.alignment: Qt.AlignHCenter
    horizontalAlignment: Text.AlignHCenter
    elide: Text.ElideRight
    visible: MediaService.hasActive
    text: MediaService.artist
    color: Theme.textDim
    font.family: Theme.fontBody
    font.pixelSize: 11
  }

  RowLayout {
    Layout.alignment: Qt.AlignHCenter
    visible: MediaService.hasActive
    spacing: 14

    component Ctl: Text {
      id: ctl
      signal clicked()
      color: ctlHover.hovered ? Theme.accent : Theme.textDim
      font.family: Theme.fontDisplay
      font.pixelSize: 11
      font.bold: true
      font.letterSpacing: 2
      HoverHandler { id: ctlHover }
      TapHandler { onTapped: ctl.clicked() }
    }

    Ctl { text: "PREV"; onClicked: MediaService.previous() }
    Ctl { text: MediaService.isPlaying ? "PAUSE" : "PLAY"; onClicked: MediaService.playPause() }
    Ctl { text: "NEXT"; onClicked: MediaService.next() }
  }
}

