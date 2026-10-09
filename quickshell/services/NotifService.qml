pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Singleton {
  id: root

  readonly property var list: server.trackedNotifications
  readonly property int count: list ? list.values.length : 0
  readonly property bool hasAny: count > 0

  function clearAll() {
    const vals = list ? list.values : [];
    for (const n of vals.slice()) n.dismiss();  // copy: dismiss() mutates the model
  }

  NotificationServer {
    id: server
    keepOnReload: true
    bodySupported: true
    bodyMarkupSupported: true
    imageSupported: true
    actionsSupported: true
    onNotification: (notification) => { notification.tracked = true; }
  }
}

