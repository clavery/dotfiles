-- Include local machine variables
require("localvars")
-- localHomeSSID = "ssidhere"
-- s3bucket = "bucketname"

local log = hs.logger.new('init','debug')

local cmd = {"cmd"}
local hyper = {"cmd", "ctrl"}

hs.hotkey.bind(hyper, "R", function()
  hs.reload()
end)


-------
-- Window Management
-------

-- Screens
--Predicate that checks if a window belongs to a screen
function isInScreen(screen, win)
  return win:screen() == screen
end

-- Brings focus to the scren by setting focus on the front-most application in it.
-- Also move the mouse cursor to the center of the screen. This is because
-- Mission Control gestures & keyboard shortcuts are anchored, oddly, on where the
-- mouse is focused.
function focusScreen(screen)
  --Get windows within screen, ordered from front to back.
  --If no windows exist, bring focus to desktop. Otherwise, set focus on
  --front-most application window.
  local windows = hs.fnutils.filter(
      hs.window.orderedWindows(),
      hs.fnutils.partial(isInScreen, screen))
  local windowToFocus = #windows > 0 and windows[1] or hs.window.desktop()
  windowToFocus:focus()

  -- Move mouse to center of screen
  local pt = hs.geometry.rectMidPoint(windowToFocus:frame())
  hs.mouse.setAbsolutePosition(pt)
end
hs.hotkey.bind({"alt"}, "`", function ()
  focusScreen(hs.window.focusedWindow():screen():next())
end)


hs.hotkey.bind(hyper, "p", function()
    local win = hs.window.focusedWindow()
    win:moveOneScreenEast(true, true, 0)
end)
hs.hotkey.bind(hyper, "o", function()
    local win = hs.window.focusedWindow()
    win:moveOneScreenWest(true, true, 0)
end)
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

hs.hotkey.bind(hyper, "n", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x 
    f.y = max.y + (max.h / 2)
    f.w = max.w / 2
    f.h = max.h / 2
    win:setFrame(f)
end)
hs.hotkey.bind(hyper, "m", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x + (max.w / 2)
    f.y = max.y + (max.h / 2)
    f.w = max.w / 2
    f.h = max.h / 2
    win:setFrame(f)
end)
hs.hotkey.bind(hyper, "u", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x
    f.y = max.y
    f.w = max.w / 2
    f.h = max.h / 2
    win:setFrame(f)
end)

-- Fuzzy Window Switcher

_fuzzyChoices = nil
_fuzzyChooser = nil
_fuzzyLastWindow = nil

function fuzzyQuery(s, m)
  s_index = 1
  m_index = 1
  match_start = nil
  while true do
    if s_index > s:len() or m_index > m:len() then
      return -1
    end
    s_char = s:sub(s_index, s_index)
    m_char = m:sub(m_index, m_index)
    if s_char == m_char then
      if match_start == nil then
        match_start = s_index
      end
      s_index = s_index + 1
      m_index = m_index + 1
      if m_index > m:len() then
        match_end = s_index
        s_match_length = match_end-match_start
        score = m:len()/s_match_length
        return score
      end
    else
      s_index = s_index + 1
    end
  end
end

function _fuzzyFilterChoices(query)
  if query:len() == 0 then
    _fuzzyChooser:choices(_fuzzyChoices)
    return
  end
  pickedChoices = {}
  for i,j in pairs(_fuzzyChoices) do
    -- fullText = (j["text"] .. " " .. j["subText"]):lower()
    fullText = (j["text"]):lower()
    score = fuzzyQuery(fullText, query:lower())
    if score > 0 then
      j["fzf_score"] = score
      table.insert(pickedChoices, j)
    end
  end
  local sort_func = function( a,b ) return a["fzf_score"] > b["fzf_score"] end
  table.sort( pickedChoices, sort_func )
  _fuzzyChooser:choices(pickedChoices)
end

function _fuzzyPickWindow(item)
  if item == nil then
    if _fuzzyLastWindow then
      -- Workaround so last focused window stays focused after dismissing
      _fuzzyLastWindow:focus()
      _fuzzyLastWindow = nil
    end
    return
  end
  id = item["windowID"]
  window = hs.window.get(id)
  window:focus()
end

function windowFuzzySearch()
  windows = hs.window.filter.default:getWindows(hs.window.filter.sortByFocusedLast)
  -- windows = hs.window.orderedWindows()
  _fuzzyChoices = {}
  for i,w in pairs(windows) do
    title = w:title()
    app = w:application():name()
    item = {
      ["text"] = app .. " - " .. title,
      --["image"] = w:snapshot(),
      ["windowID"] = w:id()
    }
    -- Handle special cases as necessary
    --if app == "Safari" and title == "" then
    -- skip, it's a weird empty window that shows up sometimes for some reason
    --else
    table.insert(_fuzzyChoices, item)
    --end
  end
  _fuzzyLastWindow = hs.window.focusedWindow()
  _fuzzyChooser = hs.chooser.new(_fuzzyPickWindow):choices(_fuzzyChoices):searchSubText(true)
  _fuzzyChooser:queryChangedCallback(_fuzzyFilterChoices) -- Enable true fuzzy find
  _fuzzyChooser:show()
end

hs.hotkey.bind("ctrl-cmd", "e", function()
  windowFuzzySearch()
end)

-- expose = hs.expose.new(nil,{showThumbnails=false, closeModeModifier='alt'}) -- default windowfilter, no thumbnails
-- hs.hotkey.bind('ctrl-cmd','e','Expose',function()expose:toggleShow()end)

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

--
--Terminal
--
local lastwindow = nil
hs.hotkey.bind(hyper, "c", function()
  terminal = hs.window.find("terminal")
  if (hs.window.focusedWindow() == terminal and lastwindow) then
    lastwindow:focus()
  elseif terminal then
    lastwindow = hs.window.focusedWindow()
    terminal:focus()
  end
end)

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


function grid()
  hs.grid.show()
end
hs.hotkey.bind(hyper, "g", grid)
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


-- Chooser Boxes
local chooser = nil
local phone = localPhoneNumber

local function createNewTimer(seconds, message)
    hs.timer.doAfter(seconds, function()
      hs.notify.new({title="Reminder",informativeText=message, autoWithdraw=false,hasActionButton=false}):send()
      local sound = hs.sound.getByName("Glass")
      sound:loopSound(true)
      sound:play()
      hs.timer.doAfter(2.5, function()
        sound:stop()
      end)

      hs.messages.iMessage(phone, message)
    end)
end

function toPath(...) return table.concat({...}, '/') end

function readAll(file)
    local f = io.open(file, "rb")
    local content = f:read("*all")
    f:close()
    return content
end

function appendToFile(file, text)
  if text == '' then return end

  local f = io.open(file, 'a')
  f:write(tostring(text) .. '\n')
  f:close()
end

function prependToFile(file, text)
  if text == '' then return end

  local out = io.open(file, 'r')

  local lines = {}
  for line in out:lines() do
    table.insert(lines, line)
  end

  out:close()

  table.insert(lines, 1, tostring(text))

  local out = io.open(file .. '.tmp', 'w')
  for _, line in ipairs(lines) do
    out:write(line .. "\n")
  end
  out:close()

  os.remove(file)
  os.rename(file .. ".tmp", file)
end

function splitline(str, pat)
  local t = {}  -- NOTE: use {n = 0} in Lua-5.0
  local fpat = "(.-)" .. pat
  local lastEnd = 1
  local s, e, cap = str:find(fpat, 1)
  while s do
    if s ~= 1 or cap ~= "" then
      table.insert(t,cap)
    end
    lastEnd = e+1
    s, e, cap = str:find(fpat, lastEnd)
  end
  if lastEnd <= #str then
    cap = str:sub(lastEnd)
    table.insert(t, cap)
  end
  return t
end

local function parseLine(line)
  local message
  local seconds = 10*60
  local parts = splitline(line, ' ')
  local first = table.remove(parts, 1)
  local rest = table.concat(parts, ' ')

  -- TODO: allow 10s, 10m, 1h, etc???
  if tonumber(first) ~= nil then
    local minutes = tonumber(first)
    seconds = math.max(1, math.floor(minutes * 60))
    message = rest
  else
    message = first .. ' ' .. rest
  end

  log.i("Setting timer for " .. seconds .. " seconds")
  createNewTimer(seconds, message)
  hs.notify.new({title="Timer Set",informativeText="Setting timer for " .. seconds/60 .. " minutes", autoWithdraw=true,hasActionButton=false}):send()
end

local homeDir = os.getenv('HOME')

local function parseTimeEntry(line)
  local message
  local time
  local parts = splitline(line, ' ')

  local timeraw = table.remove(parts, 1)
  local project = table.remove(parts, 1)

  local message = table.concat(parts, ' ')

  local date = os.date("%Y/%m/%d")

  time = tonumber(timeraw)

  appendToFile(toPath(homeDir, "Nextcloud", "Todo", "pixelmedia.txt"), date .. "," .. string.upper(project) ..",".. time ..",Backend Development,".. string.upper(project) .. ": " .. message)
end

local commands = {
  {
    ['text'] = 'File work task...',
    ['subText'] = 'File a new task/note',
    ['command'] = 'newnote',
  },
  {
    ['text'] = 'File personal task...',
    ['subText'] = 'File a new task/note',
    ['command'] = 'newnotepersonal',
  },
  {
    ['text'] = 'Time Entry',
    ['subText'] = 'File a timesheet entry',
    ['command'] = 'newtime',
  },
  {
    ['text'] = 'New Timer...',
    ['subText'] = 'Create a Timer',
    ['command'] = 'newtimer',
  },
}


function choice()
  chooser = hs.chooser.new(function(choice)
    if not choice then
      return
    end
    if choice.command == 'newtimer' then
      parseLine(tostring(chooser:query()))
    elseif choice.command == 'newnote' then
      prependToFile(toPath(homeDir, "Nextcloud", "Todo", "pixelmedia.txt"), "- " .. chooser:query())
    elseif choice.command == 'newnotepersonal' then
      prependToFile(toPath(homeDir, "Nextcloud", "Todo", "personal.txt"), "- " .. chooser:query())
    elseif choice.command == 'newtime' then
      parseTimeEntry(tostring(chooser:query()))
    end
  end)
  chooser:choices(commands)
  chooser:rows(#commands)
  chooser:queryChangedCallback(function() end)
  chooser:show()
end
hs.hotkey.bind(hyper, "y", choice)

-- screenshots with 
local screenshotbucket = s3bucket
function execute(command)
    -- returns success, error code, output.
    local f = io.popen(command..' 2>&1 && echo " $?"')
    local output = f:read"*a"
    print(output) 
    local begin, finish, code = output:find" (%d+)\n$"
    output, code = output:sub(1, begin -1), tonumber(code)
    return code == 0 and true or false, code, output
end
function string.ends(String,End)
   return End=='' or string.sub(String,-string.len(End))==End
end
function string.starts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end
function urlencode(str)
   if (str) then
      str = string.gsub (str, "\n", "\r\n")
      str = string.gsub (str, " ", "%%20")
   end
   return str    
end

local lastscreenshot = nil
function uploadscreenshots(changes)
  for key,value in pairs(changes) do 
    if value:ends(".png") and value ~= last then
      if string.starts(value, os.getenv("HOME") .. "/Documents/screenshots/.") then
        print(value)
      else
        string.format("/usr/local/bin/aws-vault exec personal -- /usr/local/bin/aws s3 cp %q s3://%s/screenshots/ --acl public-read", value, screenshotbucket)
        success, code, output = execute(string.format("/usr/local/bin/aws-vault exec personal -- /usr/local/bin/aws s3 cp %q s3://%s/screenshots/ --acl public-read", value, screenshotbucket))

        local file = string.match(value, "^.+/(.+)$")
        message = "https://" .. screenshotbucket .. ".s3.amazonaws.com/screenshots/" .. urlencode(file)
        hs.notify.new(function ()
          hs.execute("open -R '" .. value .. "'")
        end, {title="Screenshot",informativeText=message, autoWithdraw=true,hasActionButton=false}):send()
        hs.pasteboard.setContents(message)
        last = value
      end
    end
  end
end

function convertscreencasts(changes)
  for key,value in pairs(changes) do 
    if value:ends(".mov") and value ~= last then
      success, code, output = execute(string.format("/Users/clavery/bin/convertmovtogif %q", value))
  log.i(output)
    end
  end
end
function uploadscreencasts(changes)
  for key,value in pairs(changes) do 
    if value:ends(".gif") and value ~= last then
      success, code, output = execute(string.format("/usr/local/bin/aws-vault exec personal -- /Users/clavery/.local/bin/aws s3 cp %q s3://%s/screencasts/ --acl public-read", value, screenshotbucket))

      local file = string.match(value, "^.+/(.+)$")
      message = "https://" .. screenshotbucket .. ".s3.amazonaws.com/screencasts/" .. urlencode(file)
      hs.notify.new(function ()
        hs.execute("open -R '" .. value .. "'")
      end, {title="Screencast",informativeText=message, autoWithdraw=true,hasActionButton=false}):send()
      hs.pasteboard.setContents(message)
      last = value
    end
  end
end

hs.pathwatcher.new(os.getenv("HOME") .. "/Documents/screenshots/", uploadscreenshots):start()
hs.pathwatcher.new(os.getenv("HOME") .. "/Documents/screencasts/", convertscreencasts):start()
hs.pathwatcher.new(os.getenv("HOME") .. "/Documents/screencasts/", uploadscreencasts):start()
-- Show message when reloaded
hs.alert.show("HS Config loaded")

