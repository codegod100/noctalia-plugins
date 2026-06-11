local enabled = noctalia.state.get("enabled") == true

local function labelForState()
  if enabled then
    return shortcut.getConfig("on_label") or "Focus on"
  end

  return shortcut.getConfig("off_label") or "Focus off"
end

local function render()
  shortcut.setLabel(labelForState())
  shortcut.setIcon("moon-stars", "moon")
  shortcut.setActive(enabled)
  shortcut.setEnabled(true)
end

noctalia.setUpdateInterval(1000)
render()

function update()
  render()
end

function onClick()
  enabled = not enabled
  noctalia.state.set("enabled", enabled)
  render()

  if shortcut.getConfig("notify") ~= false then
    local body = enabled and "Focus mode enabled" or "Focus mode disabled"
    noctalia.notify("Focus Toggle", body)
  end
end

function onIpc(event, payload)
  if event == "set" then
    enabled = payload == "on" or payload == "true" or payload == "1"
    noctalia.state.set("enabled", enabled)
    render()
    return
  end

  if event == "toggle" then
    onClick()
  end
end
