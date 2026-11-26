import QtQuick
import Quickshell
import Quickshell.Io
import qs.Ui
import qs.Commons
import qs.Commons as Commons

// YouTube audio-only player: paste a URL (or type a search term), mpv plays
// just the audio stream. Controlled directly via mpv's JSON IPC socket.
// Left click: open panel. Middle click: play/pause. Right click: stop.
BarWidget {
  id: root
  moduleName: "henning.yt-audio"

  readonly property string socketPath: (Quickshell.env("XDG_RUNTIME_DIR") || "/tmp") + "/henning-yt-audio.sock"
  readonly property string ytdlFormat: "bestaudio[abr<=70]/worstaudio"

  property bool popupOpen: false
  property string statusText: ""
  property string pendingTarget: ""
  property string mediaTitle: ""
  property bool paused: false
  property string currentInput: ""

  // Playback position tracking (resume where you left off).
  property real lastPos: 0        // seconds, from mpv time-pos
  property real duration: 0
  property bool loading: false    // true between loadfile and file-loaded; ignores stale time-pos
  property real resumePos: 0      // position to seek to once the file is loaded

  function fmtTime(sec) {
    sec = Math.floor(sec)
    var h = Math.floor(sec / 3600), m = Math.floor((sec % 3600) / 60), s = sec % 60
    var mm = (h > 0 && m < 10 ? "0" : "") + m
    return (h > 0 ? h + ":" : "") + mm + ":" + (s < 10 ? "0" : "") + s
  }

  function savedPos(input) {
    for (var i = 0; i < history.length; i++)
      if (history[i].input === input) return history[i].pos || 0
    return 0
  }

  // Persist the current position into the history entry of the running track.
  function saveProgress() {
    if (currentInput === "" || loading || lastPos <= 0) return
    // Near the end (or finished): reset so the next play starts from the beginning.
    var pos = (duration > 0 && lastPos > duration - 15) ? 0 : Math.floor(lastPos)
    var list = history.slice()
    for (var i = 0; i < list.length; i++) {
      if (list[i].input === currentInput) {
        if ((list[i].pos || 0) === pos) return
        list[i] = { input: list[i].input, title: list[i].title, pos: pos }
        history = list
        saveHistory()
        return
      }
    }
  }

  // Last 10 played entries: [{ input, title, pos }], newest first.
  readonly property int historyMax: 10
  readonly property string historyPath: (Quickshell.env("XDG_STATE_HOME") || (Quickshell.env("HOME") + "/.local/state")) + "/henning-yt-audio-history.json"
  property var history: []

  function saveHistory() {
    historyFile.setText(JSON.stringify(history, null, 2) + "\n")
  }

  function addHistory(input) {
    var list = [{ input: input, title: "", pos: 0 }]
    for (var i = 0; i < history.length && list.length < historyMax; i++) {
      if (history[i].input === input) { list[0].title = history[i].title || ""; list[0].pos = history[i].pos || 0 }
      else list.push(history[i])
    }
    history = list
    saveHistory()
  }

  onMediaTitleChanged: {
    if (mediaTitle === "" || currentInput === "") return
    var list = history.slice()
    for (var i = 0; i < list.length; i++) {
      if (list[i].input === currentInput && list[i].title !== mediaTitle) {
        list[i] = { input: list[i].input, title: mediaTitle, pos: list[i].pos || 0 }
        history = list
        saveHistory()
        return
      }
    }
  }

  FileView {
    id: historyFile
    path: root.historyPath
    atomicWrites: true
    printErrors: false
    onLoaded: {
      try {
        var data = JSON.parse(text())
        if (Array.isArray(data)) root.history = data.slice(0, root.historyMax)
      } catch (e) {}
    }
  }

  readonly property bool playing: mpvProc.running
  readonly property string title: mediaTitle !== "" ? mediaTitle : (playing ? "Lädt…" : "")

  // Shape contract for the bar's popout routing.
  readonly property bool opened: popupOpen
  function open() { popupOpen = true }
  function close() { popupOpen = false }

  function send(cmd) {
    if (ipc.connected) ipc.write(JSON.stringify({ command: cmd }) + "\n")
  }

  function play(input) {
    var text = String(input || "").trim()
    if (text === "") return
    var target = /^https?:\/\//.test(text) ? text : "ytdl://ytsearch:" + text
    statusText = ""
    saveProgress()  // flush position of the track we are leaving
    var resume = savedPos(text)
    currentInput = text
    addHistory(text)
    loading = true
    lastPos = 0
    duration = 0
    resumePos = resume
    if (mpvProc.running) {
      // Reuse the running mpv: just load the new track.
      send(["loadfile", target, "replace"])
      mediaTitle = ""
      send(["set_property", "pause", false])
      return
    }
    start(target)
  }

  function start(target) {
    mediaTitle = ""
    paused = false
    loading = true
    mpvProc.command = ["mpv", "--no-video", "--no-terminal", "--idle=no",
                       "--input-ipc-server=" + socketPath,
                       "--ytdl-format=" + ytdlFormat,
                       // Large read-ahead buffer so short network hiccups don't cause dropouts
                       // (mpv default is only ~1s). Audio at ~70kbps: 2 min is just ~1 MB.
                       "--cache=yes", "--demuxer-readahead-secs=180",
                       "--demuxer-max-bytes=64MiB",
                       "--network-timeout=30",
                       "--stream-lavf-o=reconnect=1,reconnect_streamed=1,reconnect_delay_max=5",
                       target]
    mpvProc.running = true
    connectTimer.restart()
  }

  function togglePause() { send(["cycle", "pause"]) }

  function stop() {
    saveProgress()
    send(["quit"])
    stopFallback.restart()
  }

  Process {
    id: mpvProc
    onExited: function(code) {
      root.saveProgress()
      connectTimer.stop()
      ipc.connected = false
      root.mediaTitle = ""
      root.paused = false
      if (code !== 0 && code !== 4 && code !== 15 && code !== 143)
        root.statusText = "Fehler beim Abspielen (mpv Exit " + code + ")"
    }
  }

  Timer {
    id: stopFallback
    interval: 1500
    onTriggered: if (mpvProc.running) mpvProc.running = false
  }

  // Periodically persist the position so a crash/logout loses at most a few seconds.
  Timer {
    interval: 5000
    repeat: true
    running: root.playing && !root.paused && !root.loading
    onTriggered: root.saveProgress()
  }

  // mpv creates the socket shortly after start; retry until connected.
  Timer {
    id: connectTimer
    interval: 300
    repeat: true
    onTriggered: {
      if (!mpvProc.running) { stop(); return }
      if (ipc.connected) { stop(); return }
      ipc.connected = true
    }
  }

  Socket {
    id: ipc
    path: root.socketPath
    onConnectionStateChanged: {
      if (connected) {
        connectTimer.stop()
        root.send(["observe_property", 1, "media-title"])
        root.send(["observe_property", 2, "pause"])
        root.send(["observe_property", 3, "time-pos"])
        root.send(["observe_property", 4, "duration"])
      }
    }
    parser: SplitParser {
      onRead: function(line) {
        var msg
        try { msg = JSON.parse(line) } catch (e) { return }
        if (msg.event === "file-loaded") {
          root.loading = false
          if (root.resumePos > 5) root.send(["seek", root.resumePos, "absolute"])
          root.resumePos = 0
          return
        }
        if (msg.event !== "property-change") return
        if (msg.name === "media-title") root.mediaTitle = msg.data ? String(msg.data) : ""
        else if (msg.name === "pause") { root.paused = !!msg.data; if (root.paused) root.saveProgress() }
        else if (msg.name === "time-pos") { if (!root.loading && msg.data !== null && msg.data !== undefined) root.lastPos = Number(msg.data) }
        else if (msg.name === "duration") { if (!root.loading) root.duration = msg.data ? Number(msg.data) : 0 }
      }
    }
  }

  implicitWidth: row.implicitWidth + Style.space(14)
  implicitHeight: barSize

  Row {
    id: row
    anchors.centerIn: parent
    spacing: Style.space(6)

    Text {
      id: glyph
      anchors.verticalCenter: parent.verticalCenter
      textFormat: Text.PlainText
      text: !root.playing ? "󰗃" : (root.paused ? "󰐊" : "󰏤")
      color: root.playing ? root.bar.barForeground : Qt.darker(root.bar.barForeground, 1.4)
      font.family: root.bar.fontFamily
      font.pixelSize: Style.font.body
    }
  }

  MouseArea {
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
    onClicked: function(mouse) {
      if (mouse.button === Qt.MiddleButton) root.togglePause()
      else if (mouse.button === Qt.RightButton) root.stop()
      else root.popupOpen = !root.popupOpen
    }
    onEntered: if (root.bar) root.bar.showTooltip(root, "YouTube Audio")
    onExited: if (root.bar) root.bar.hideTooltip(root)
  }

  KeyboardPanel {
    id: panel
    anchorItem: root
    owner: root
    bar: root.bar
    open: root.popupOpen
    focusTarget: input
    contentWidth: panel.fittedContentWidth(Style.space(380))
    contentHeight: panel.fittedContentHeight(column.implicitHeight)

    Column {
      id: column
      anchors.fill: parent
      spacing: Style.space(10)

      Text {
        textFormat: Text.PlainText
        text: "YouTube Audio"
        color: root.bar.foreground
        font.family: root.bar.fontFamily
        font.pixelSize: Style.font.subtitle
        font.bold: true
      }

      TextField {
        id: input
        width: parent.width
        foreground: root.bar.foreground
        placeholderText: "URL einfügen oder suchen…"
        onAccepted: { root.play(text); text = "" }
        Keys.onEscapePressed: root.close()
      }

      Text {
        textFormat: Text.PlainText
        width: parent.width
        elide: Text.ElideRight
        text: root.statusText !== "" ? root.statusText
              : (root.playing ? (root.paused ? "Pausiert: " : "Spielt: ") + root.title : "Nichts läuft")
        color: Qt.darker(root.bar.foreground, 1.3)
        font.family: root.bar.fontFamily
        font.pixelSize: Style.font.bodySmall
      }

      Row {
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: Style.space(6)

        Button {
          iconText: "󰐊"
          foreground: root.bar.foreground
          horizontalPadding: Style.spacing.controlPaddingX
          verticalPadding: Style.spacing.controlPaddingY
          enabled: input.text.trim() !== "" || (root.playing && root.paused)
          opacity: enabled ? 1.0 : 0.4
          onClicked: {
            if (input.text.trim() !== "") { root.play(input.text); input.text = "" }
            else root.send(["set_property", "pause", false])
          }
        }

        Button {
          iconText: "󰏤"
          foreground: root.bar.foreground
          horizontalPadding: Style.spacing.controlPaddingX
          verticalPadding: Style.spacing.controlPaddingY
          enabled: root.playing && !root.paused
          opacity: enabled ? 1.0 : 0.4
          onClicked: root.send(["set_property", "pause", true])
        }

        Button {
          iconText: "󰓛"
          foreground: root.bar.foreground
          horizontalPadding: Style.spacing.controlPaddingX
          verticalPadding: Style.spacing.controlPaddingY
          enabled: root.playing
          opacity: enabled ? 1.0 : 0.4
          onClicked: root.stop()
        }
      }

      PanelSeparator {
        visible: root.history.length > 0
        foreground: root.bar.foreground
      }

      Text {
        visible: root.history.length > 0
        textFormat: Text.PlainText
        text: "Zuletzt gespielt"
        color: Qt.darker(root.bar.foreground, 1.3)
        font.family: root.bar.fontFamily
        font.pixelSize: Style.font.caption
      }

      Column {
        id: historyList
        visible: root.history.length > 0
        width: parent.width
        spacing: Style.space(2)

        Repeater {
          model: root.history

          BorderSurface {
            id: entry
            required property var modelData
            readonly property bool current: root.playing && modelData.input === root.currentInput

            width: historyList.width
            height: entryText.implicitHeight + Style.space(8)
            radius: Style.spacing.labelGap
            color: current ? Style.selectedFillFor(root.bar.foreground, Commons.Color.accent)
                   : (entryMouse.containsMouse ? Style.normalFillFor(root.bar.foreground, Commons.Color.accent) : "transparent")
            borderSpec: Border.none()

            Text {
              id: entryText
              anchors.left: parent.left
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              anchors.leftMargin: Style.space(8)
              anchors.rightMargin: Style.space(8)
              textFormat: Text.PlainText
              elide: Text.ElideRight
              text: (entry.current ? "󰝚  " : "") + (entry.modelData.title || entry.modelData.input)
                    + (entry.modelData.pos > 5 ? "  · " + root.fmtTime(entry.modelData.pos) : "")
              color: root.bar.foreground
              font.family: root.bar.fontFamily
              font.pixelSize: Style.font.bodySmall
              font.bold: entry.current
            }

            MouseArea {
              id: entryMouse
              anchors.fill: parent
              hoverEnabled: true
              cursorShape: Qt.PointingHandCursor
              onClicked: root.play(entry.modelData.input)
            }
          }
        }
      }
    }
  }
}
