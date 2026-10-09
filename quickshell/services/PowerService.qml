// PowerService.qml
// NOTE: Quickshell's UPowerDevice.percentage is a FRACTION (0.0 .. 1.0),
// NOT 0..100 like the `upower` CLI shows.
pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.UPower

Singleton {
  id: root

  readonly property UPowerDevice device: UPower.displayDevice
  readonly property bool ready: device && device.ready
  readonly property bool hasBattery: ready && device.isLaptopBattery

  // Charge as 0.0 .. 1.0 (rescales defensively if ever given 0..100).
  readonly property real level: {
    if (!ready) return 0;
    const p = device.percentage;
    return Math.max(0, Math.min(1, p > 1 ? p / 100 : p));
  }
  readonly property int percent: Math.round(level * 100)

  readonly property bool charging: ready
    && (device.state === UPowerDeviceState.Charging
        || device.state === UPowerDeviceState.PendingCharge)
  readonly property bool full: ready && device.state === UPowerDeviceState.FullyCharged
  readonly property bool onBattery: UPower.onBattery

  readonly property bool low: hasBattery && !charging && percent <= 20
  readonly property bool critical: hasBattery && !charging && percent <= 10

  readonly property real timeToEmpty: ready ? device.timeToEmpty : 0
  readonly property real timeToFull: ready ? device.timeToFull : 0
}

