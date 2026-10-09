// BluetoothService.qml
pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Bluetooth

Singleton {
  id: root

  readonly property BluetoothAdapter adapter: Bluetooth.defaultAdapter
  readonly property bool available: !!adapter
  readonly property bool powered: available && adapter.enabled

  readonly property var devices: Bluetooth.devices
  readonly property var connectedDevices: {
    const out = [];
    const vals = Bluetooth.devices ? Bluetooth.devices.values : [];
    for (const d of vals) if (d.connected) out.push(d);
    return out;
  }
  readonly property bool hasConnection: connectedDevices.length > 0

  function toggle() { if (available) adapter.enabled = !adapter.enabled; }
  function setDiscovering(on) { if (available) adapter.discovering = on; }

  // DEBUG: remove once bluetooth shows correctly.
  Component.onCompleted: logState()
  onAdapterChanged: logState()
  onPoweredChanged: logState()
  function logState() {
    console.log("[BluetoothService] adapter:",
      available ? `${adapter.name} (${adapter.adapterId}) enabled=${adapter.enabled}` : "NONE");
  }
}

