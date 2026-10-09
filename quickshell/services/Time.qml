// Time.qml
pragma Singleton
import QtQuick
import Quickshell

Singleton {
  id: root

  property date now: new Date()

  property string hour: Qt.formatDateTime(now, "hh")
  property string minute: Qt.formatDateTime(now, "mm")
  property string second: Qt.formatDateTime(now, "ss")

  property string day: Qt.formatDateTime(now, "dd")
  property string month: Qt.formatDateTime(now, "MM")
  property string year: Qt.formatDateTime(now, "yyyy")
  property string yearHigh: year.slice(0,2)
  property string yearLow: year.slice(2,4)

  Timer {
    interval: 1000
    running: true
    repeat: true
    onTriggered: root.now = new Date()
  }
}
