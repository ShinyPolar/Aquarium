// ClockWidget.qml
import QtQuick
import "../services"

Column {
  spacing: 2
  Text { text: Time.hour }
  Text { text: Time.minute }
  Text { text: Time.second }
}
