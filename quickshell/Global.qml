// Global.qml
pragma Singleton
import Quickshell
import Quickshell.Hyprland

Singleton {
  id: root

  property bool expanded: false

  property string activePanel: ""
  property bool locked: false

  function request(panelName) {
    // TODO: your rule from earlier —
    // if locked and someone else owns it, deny... unless force is true
    if (locked && activePanel !== panelName) return false
    if (activePanel == panelName) {
	    root.release(panelName)
	    return false
    }
    activePanel = panelName
    
    return true
  }

  function release(panelName) {
    // TODO: only actually clear activePanel/locked
    // if panelName is the one that currently holds it
    if (activePanel == panelName)
    {
    	locked = false
    	activePanel = ""
    }
  }
  GlobalShortcut {
    name: "toggleRightPanel"
    onPressed: root.expanded = !root.expanded
  }
}
