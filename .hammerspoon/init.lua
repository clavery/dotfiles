-- Include local machine variables
require("localvars")


local hyper = {"cmd", "ctrl"}

hs.hotkey.bind(hyper, "R", function()
  hs.reload()
end)


-------
-- Window Management
-------

-- Fullscreen
hs.hotkey.bind(hyper, "f", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x
    f.y = max.y
    f.w = max.w
    f.h = max.h
    win:setFrame(f)
end)
-- Left
hs.hotkey.bind(hyper, "h", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x
    f.y = max.y
    f.w = max.w / 2
    f.h = max.h
    win:setFrame(f)
end)
hs.hotkey.bind(hyper, "l", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x + (max.w / 2)
    f.y = max.y
    f.w = max.w / 2
    f.h = max.h
    win:setFrame(f)
end)
hs.hotkey.bind(hyper, "k", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x
    f.y = max.y
    f.w = max.w
    f.h = max.h / 2
    win:setFrame(f)
end)
hs.hotkey.bind(hyper, "j", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x
    f.y = max.y + (max.h / 2)
    f.w = max.w
    f.h = max.h / 2
    win:setFrame(f)
end)

-- Window Hints
hs.hints.showTitleThresh = 4
hs.hints.fontName = "SourceCodePro-Bold"
hs.hints.fontSize = 16
hs.hotkey.bind(hyper, "o", function()
  local windows = {}
  local runningApps = hs.application.runningApplications()

  for i,app in ipairs(runningApps) do
    windows[#windows+1] = app:mainWindow()
  end
  hs.hints.windowHints(windows)
end)
hs.hotkey.bind(hyper, "p", function()
  hs.hints.showTitleThresh = 10
  hs.hints.windowHints(hs.window.focusedWindow():application():allWindows())
  hs.hints.showTitleThresh = 4
end)

---------
-- Caffine replacement
---------

local caffeine = hs.menubar.new()
function setCaffeineDisplay(state)
    if state then
        caffeine:setTitle("☀")
    else
        caffeine:setTitle("☁")
    end
end

function caffeineClicked()
    setCaffeineDisplay(hs.caffeinate.toggle("displayIdle"))
end

if caffeine then
    caffeine:setClickCallback(caffeineClicked)
    setCaffeineDisplay(hs.caffeinate.get("displayIdle"))
end


---------
-- Set volume to 0 on external wifi change
---------

local wifiWatcher = nil
local homeSSID = localHomeSSID
local lastSSID = hs.wifi.currentNetwork()

function ssidChangedCallback()
    newSSID = hs.wifi.currentNetwork()

    if newSSID ~= homeSSID and lastSSID == homeSSID then
        hs.alert.show("Wifi Change - Zeroing Volume", 5)
        hs.audiodevice.defaultOutputDevice():setVolume(0)
    end

    lastSSID = newSSID
end

wifiWatcher = hs.wifi.watcher.new(ssidChangedCallback)
wifiWatcher:start()


------
-- Find mouse cursor
------

local mouseCircle = nil
local mouseCircleTimer = nil
function mouseHighlight()
    -- Delete an existing highlight if it exists
    if mouseCircle then
        mouseCircle:delete()
        if mouseCircleTimer then
            mouseCircleTimer:stop()
        end
    end
    -- Get the current co-ordinates of the mouse pointer
    mousepoint = hs.mouse.getAbsolutePosition()
    -- Prepare a big red circle around the mouse pointer
    mouseCircle = hs.drawing.circle(hs.geometry.rect(mousepoint.x-40, mousepoint.y-40, 80, 80))
    mouseCircle:setStrokeColor({["red"]=1,["blue"]=0,["green"]=0,["alpha"]=1})
    mouseCircle:setFill(true)
    mouseCircle:setStrokeWidth(5)
    mouseCircle:show()

    -- Set a timer to delete the circle after 3 seconds
    mouseCircleTimer = hs.timer.doAfter(3, function() mouseCircle:delete() end)
end
hs.hotkey.bind(hyper, "D", mouseHighlight)


-------
-- Alt Pasteboard
-------

function copyToAltPasteboard()
  hs.alert.show("Copied to alt pasteboard", 1)
  hs.pasteboard.setContents(hs.pasteboard.getContents(), "alt")
end
function copyFromAltPasteboard()
  hs.alert.show("Copied from alt pasteboard", 1)
  hs.pasteboard.setContents(hs.pasteboard.getContents("alt"))
end
hs.hotkey.bind(hyper, "C", copyToAltPasteboard)
hs.hotkey.bind(hyper, "V", copyFromAltPasteboard)


-------
-- Statuses
-------

local statusText = nil
function renderStatuslets()
  local win = hs.window.focusedWindow()
  local screen = win:screen()
  local max = screen:frame()
  local textColor = {["red"]=1,["blue"]=0,["green"]=0,["alpha"]=1}

  if statusText then
    statusText:delete()
    statusText = nil
    return
  end

  hs.http.asyncGet("https://httpbin.org/ip", nil, function(statusCode, body, headers)
    local response = hs.json.decode(body)
    local origin = response["origin"]

    statusText = hs.drawing.text(hs.geometry.rect(max.x + (max.w / 2), 200, max.w / 2, (max.h - 200)), "External IP: " .. origin)
    statusText:setTextFont("SourceCodePro-Bold")
    statusText:setTextColor(textColor)
    statusText:setTextSize(22)
    statusText:show()
  end)
end
hs.hotkey.bind(hyper, "i", renderStatuslets)

function describeApplicationState()
  print('application:', hs.window.focusedWindow():application():title())
  print('bundleId:', hs.window.focusedWindow():application():bundleID())
  print('pid:', hs.window.focusedWindow():application():pid())
  print('window id:', hs.window.focusedWindow():id())
end
hs.hotkey.bind(hyper, "w", describeApplicationState)
hs.hotkey.bind(hyper, "q", hs.toggleConsole)


-- Input Boxes
function setReminder()
  success, result = hs.applescript.applescript([[
  display dialog "Reminder text" default answer ""
  text returned of result
  ]])
  hs.timer.doAfter(60*10, function()
    hs.notify.new({title="Reminder",informativeText=result, autoWithdraw=false,hasActionButton=false}):send()
  end)
  --hs.timer.doAfter(
end
hs.hotkey.bind(hyper, "y", setReminder)


-- Show message when reloaded
hs.alert.show("HS Config loaded")


