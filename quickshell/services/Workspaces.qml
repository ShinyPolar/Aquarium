pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Hyprland

Singleton {
  id: root

  readonly property var list: Hyprland.workspaces          // sorted by id
  readonly property var focused: Hyprland.focusedWorkspace
  readonly property int focusedId: focused ? focused.id : -1
  readonly property int count: list ? list.values.length : 0

  function focus(id)    { Hyprland.dispatch(`workspace ${id}`); }
  function isActive(id) { return id === focusedId; }
  function refresh()    { Hyprland.refreshWorkspaces(); }
}

