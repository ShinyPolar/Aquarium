pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// Ref-counted: cava only runs while some widget has called acquire().
Singleton {
  id: root

  readonly property int barCount: 36
  property var values: zeros()
  property int users: 0
  property bool available: true
  readonly property bool running: proc.running

  function acquire() { users += 1; }
  function release() { users = Math.max(0, users - 1); }
  function zeros() { const a = []; for (let i = 0; i < barCount; i++) a.push(0); return a; }

  readonly property string config: [
    "[general]", "bars = " + barCount, "framerate = 60",
    "[output]", "method = raw", "raw_target = /dev/stdout",
    "data_format = ascii", "ascii_max_range = 100",
    "bar_delimiter = 59", "frame_delimiter = 10"
  ].join("
")

  Process {
    id: proc
    running: root.users > 0 && root.available
    // Plain JS string on purpose: ${...} is for sh, not JS. Config passed as $1.
    command: [
      "sh", "-c",
      'conf="${XDG_RUNTIME_DIR:-/tmp}/aquarium-cava.conf"; ' +
      'printf "%s\
" "$1" > "$conf" && exec cava -p "$conf"',
      "sh", root.config
    ]
    stdout: SplitParser {
      splitMarker: "
"
      onRead: data => {
        const parts = data.split(";");
        const out = new Array(root.barCount);
        for (let i = 0; i < root.barCount; i++)
          out[i] = Math.min(1, (parseInt(parts[i]) || 0) / 100);
        root.values = out;
      }
    }
    onExited: (exitCode, exitStatus) => {
      root.values = root.zeros();
      if (exitCode === 127) {
        root.available = false;
        console.warn("[CavaService] cava not found -- install it: sudo pacman -S cava");
      }
    }
  }
}

