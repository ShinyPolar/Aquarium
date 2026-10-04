// ClockWidget.qml
import QtQuick

Column {
  id: root
  spacing: 2
  anchors.top: parent.top
  anchors.horizontalCenter: parent.horizontalCenter
  Text { text: Time.hour;  horizontalAlignment: Text.AlignHCenter }
  Text { text: Time.minute }
  Text { text: Time.second }
  Text { text: Time.yearHigh }
  Text { text: Time.yearLow }
  Text { text: Time.month }
  Text { text: Time.day }
}
