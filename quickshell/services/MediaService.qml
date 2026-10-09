// MediaService.qml
//
// Service singleton wrapping Quickshell's MPRIS integration.
// Powers the "sanity circle" now-playing visual (FR-02/03/04).
//
// Exposes a single "active player" chosen from all available MPRIS players,
// plus clean, aquarium-friendly derived properties so the UI never has to
// touch the raw player quirks.
pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Mpris

Singleton {
  id: root

  // --- Player selection ------------------------------------------------
  readonly property var players: Mpris.players

  // Preference: a Playing player, else the first available, else null
  // (null -> "wanna play?" idle state, FR-04).
  readonly property MprisPlayer active: {
    const list = Mpris.players.values;
    if (!list || list.length === 0) return null;
    for (const p of list) {
      if (p.playbackState === MprisPlaybackState.Playing) return p;
    }
    return list[0];
  }

  // --- Derived state (what the sanity circle binds to) -----------------
  readonly property bool hasActive: active !== null
  readonly property bool isPlaying: active ? active.isPlaying : false

  readonly property string title: active ? (active.trackTitle || "Unknown Title") : ""
  readonly property string artist: active ? (active.trackArtist || "Unknown Artist") : ""
  readonly property string album: active ? (active.trackAlbum || "") : ""
  readonly property string artUrl: active ? active.trackArtUrl : ""
  readonly property string playerName: active ? active.identity : ""

  readonly property real position: active ? active.position : 0
  readonly property real length: (active && active.lengthSupported && active.length > 0)
                                  ? active.length : 0
  readonly property real progress: length > 0 ? Math.min(1, position / length) : 0

  // --- Control helpers (safe no-ops when unsupported) ------------------
  function playPause() { if (active && active.canTogglePlaying) active.togglePlaying(); }
  function next()      { if (active && active.canGoNext)       active.next(); }
  function previous()  { if (active && active.canGoPrevious)   active.previous(); }

  // MPRIS doesn't push position updates; nudge once/sec so the ring animates.
  Timer {
    running: root.isPlaying
    interval: 1000
    repeat: true
    onTriggered: if (root.active) root.active.positionChanged()
  }
}

