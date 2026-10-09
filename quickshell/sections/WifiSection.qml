// WifiSection.qml
// RightPanel bottom "details" content when activePanel == "wifi" (FR-09).
// Locks the details area while the password prompt is open.
// PLACEHOLDER visuals -- plain rows, swap for chinanago art later.
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Networking
import "../services"
import ".."            // Global.qml at the config root -- adjust if you moved it

Item {
  id: root

  // --- Scanning: only while this section is actually on screen ---------
  readonly property bool onScreen: Global.expanded && Global.activePanel === "wifi"
  onOnScreenChanged: WifiService.setScanning(onScreen)
  Component.onCompleted: WifiService.setScanning(onScreen)
  Component.onDestruction: {
    WifiService.setScanning(false);
    if (promptOpen) unlockArea();   // never leave the area stuck locked
  }

  // --- Lock adapter: swap these if your Global has lock()/unlock() -----
  function lockArea()   { Global.locked = true; }
  function unlockArea() { Global.locked = false; }

  // --- Connect flow state ----------------------------------------------
  property var pendingNetwork: null
  property bool promptOpen: false
  property bool connecting: false
  property string errorText: ""

  function choose(net) {
    errorText = "";
    if (net.connected) { WifiService.disconnect(net); return; }
    if (WifiService.needsPassword(net)) { openPrompt(net); return; }
    if (!WifiService.isSupported(net)) {
      errorText = `${net.name}: ${WifiSecurityType.toString(net.security)} networks aren't supported here yet`;
      return;
    }
    pendingNetwork = net;           // open or known network: just try it
    connecting = true;
    WifiService.connect(net);
  }

  function openPrompt(net) {
    pendingNetwork = net;
    promptOpen = true;
    connecting = false;
    passwordField.text = "";
    lockArea();
    passwordField.forceActiveFocus();
  }

  function submit() {
    if (!pendingNetwork || passwordField.text.length === 0) return;
    errorText = "";
    connecting = true;
    WifiService.connectWithPsk(pendingNetwork, passwordField.text);
  }

  function closePrompt() {
    promptOpen = false;
    connecting = false;
    pendingNetwork = null;
    passwordField.text = "";        // don't keep the password around
    unlockArea();
  }

  Connections {
    target: root.pendingNetwork
    ignoreUnknownSignals: true

    function onConnectedChanged() {
      if (!root.pendingNetwork || !root.pendingNetwork.connected) return;
      if (root.promptOpen) root.closePrompt();
      else { root.connecting = false; root.pendingNetwork = null; }
    }

    function onConnectionFailed(reason) {
      root.connecting = false;
      const net = root.pendingNetwork;
      if (reason === ConnectionFailReason.NoSecrets && WifiService.supportsPassword(net)) {
        if (root.promptOpen) root.errorText = "Wrong password, try again";
        else { root.openPrompt(net); root.errorText = "Password needed"; }
        return;
      }
      root.errorText = `Couldn't connect: ${ConnectionFailReason.toString(reason)}`;
      if (!root.promptOpen) root.pendingNetwork = null;
    }
  }

  // --- UI ---------------------------------------------------------------
  ColumnLayout {
    anchors.fill: parent
    spacing: 8

    RowLayout {
      Layout.fillWidth: true
      Text {
        Layout.fillWidth: true
        elide: Text.ElideRight
        color: "white"
        text: !WifiService.available ? "No Wi-Fi device"
            : WifiService.connected  ? `Connected: ${WifiService.activeName}`
            :                          "Not connected"
      }
      Button {
        text: WifiService.enabled ? "Wi-Fi on" : "Wi-Fi off"
        enabled: WifiService.available && !root.promptOpen
        onClicked: WifiService.toggleWifi()
      }
    }

    Text {
      Layout.fillWidth: true
      visible: root.errorText !== ""
      text: root.errorText
      color: "#f5a742"
      wrapMode: Text.Wrap
    }

    // Password prompt -- details area is locked while this is visible
    ColumnLayout {
      Layout.fillWidth: true
      visible: root.promptOpen
      spacing: 6

      Text {
        color: "white"
        text: root.pendingNetwork ? `Password for ${root.pendingNetwork.name}` : ""
      }
      TextField {
        id: passwordField
        Layout.fillWidth: true
        placeholderText: "Password"
        echoMode: showPassword.checked ? TextInput.Normal : TextInput.Password
        enabled: !root.connecting
        onAccepted: root.submit()
        Keys.onEscapePressed: root.closePrompt()
      }
      RowLayout {
        Layout.fillWidth: true
        CheckBox { id: showPassword; text: "Show" }
        Item { Layout.fillWidth: true }
        Button { text: "Cancel"; onClicked: root.closePrompt() }
        Button {
          text: root.connecting ? "Connecting…" : "Connect"
          enabled: !root.connecting && passwordField.text.length > 0
          onClicked: root.submit()
        }
      }
    }

    ListView {
      Layout.fillWidth: true
      Layout.fillHeight: true
      visible: !root.promptOpen
      clip: true
      spacing: 2
      model: WifiService.sortedNetworks

      delegate: Rectangle {
        id: row
        required property var modelData
        width: ListView.view.width
        height: 30
        radius: 6
        color: rowHover.hovered    ? "#22ffffff"
             : modelData.connected ? "#331d9e75"
             :                       "transparent"

        RowLayout {
          anchors.fill: parent
          anchors.leftMargin: 8
          anchors.rightMargin: 8
          spacing: 6

          Text { Layout.fillWidth: true; elide: Text.ElideRight; color: "white"; text: row.modelData.name }
          Text {
            color: "#a6e3a1"
            text: row.modelData.stateChanging ? "…" : row.modelData.connected ? "✓" : ""
          }
          Text { text: WifiService.isSecured(row.modelData) ? "🔒" : "" }
          Text { color: "#aaffffff"; text: `${Math.round(row.modelData.signalStrength * 100)}%` }
        }

        HoverHandler { id: rowHover }
        TapHandler { onTapped: root.choose(row.modelData) }
      }
    }

    Text {
      Layout.fillWidth: true
      visible: !root.promptOpen && WifiService.sortedNetworks.length === 0
      horizontalAlignment: Text.AlignHCenter
      color: "#aaffffff"
      text: WifiService.enabled ? "Scanning…" : "Wi-Fi is off"
    }
  }
}

