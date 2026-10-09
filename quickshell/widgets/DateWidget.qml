// DateWidget.qml  (display-only, lives in the Bar)
//
// FR-13: date in 2-digit blocks stacked vertically. Display-only.
// Mirrors ClockWidget's vertical-block style. Reads the Time singleton.
//
// Shows day / month / year-low stacked (dd over MM over yy). Reorder to taste.
import QtQuick
import "../services"   // adjust path to where Time lives (if you move it there)

Column {
  spacing: 2

  Text { text: Time.yearHigh;  color: "white";  }
  Text { text: Time.yearLow;  color: "white";  }
  Text { text: Time.day;      color: "white";  }
  Text { text: Time.month;    color: "white";  }
}

