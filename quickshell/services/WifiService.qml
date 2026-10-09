// WifiService.qml
//
// Service singleton wrapping Quickshell's Networking (NetworkManager) backend,
// scoped to WiFi. Powers the chinanago wifi indicator + network list
// (FR-08 wifi state, FR-09 selecting from the list).
//
// Data + logic only -- NO UI. The chinanago visuals live in the UI layer
// and bind to the properties here.
//
// Requires: NetworkManager + DBus running.
pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Networking

Singleton {
  id: root

  // --- Device selection ------------------------------------------------
  // Pick the first WiFi device. `type == DeviceType.Wifi` means the object
  // is actually a WifiDevice (so scannerEnabled / WifiNetwork props exist).
  readonly property var device: {
    const devs = Networking.devices ? Networking.devices.values : [];
    for (const d of devs) if (d.type === DeviceType.Wifi) return d;
    return null;
  }

  readonly property bool available: device !== null

  // Global rfkill switches (software + hardware block).
  readonly property bool enabled: Networking.wifiEnabled
  readonly property bool hardwareEnabled: Networking.wifiHardwareEnabled

  // --- Networks (what the chinanago list binds to) --------------------
  // Only WifiNetwork instances, since `device` is a WifiDevice.
  readonly property var networks: device ? device.networks : null

  // The currently connected network (or null). Drives the "which chinanago
  // is lit" state and the collapsed-strip wifi glyph.
  readonly property var activeNetwork: {
    const nets = networks ? networks.values : [];
    for (const n of nets) if (n.connected) return n;
    return null;
  }

  readonly property bool connected: activeNetwork !== null
  readonly property string activeName: activeNetwork ? activeNetwork.name : ""
  // Signal strength 0.0..1.0 of the active network (WifiNetwork prop).
  readonly property real activeSignal: activeNetwork ? activeNetwork.signalStrength : 0

  // --- Scanning --------------------------------------------------------
  // Turn scanning on/off. The expanded panel calls setScanning(true) while
  // open so the chinanago list stays fresh, and setScanning(false) on close.
  function setScanning(on) {
    if (device) device.scannerEnabled = on;
  }

  // --- Connect helpers -------------------------------------------------
  // Try a plain connect first (works for open or already-known networks).
  // The UI should listen for Network.connectionFailed() and only then prompt
  // for a PSK, calling connectWithPsk().
  function connect(network) {
    if (network) network.connect();
  }
  function connectWithPsk(network, psk) {
    if (network) network.connectWithPsk(psk);
  }
  function disconnect(network) {
    if (network) network.disconnect();
  }

  // Convenience for toggling wifi power from the panel.
  function toggleWifi() {
    Networking.wifiEnabled = !Networking.wifiEnabled;
  }
}

