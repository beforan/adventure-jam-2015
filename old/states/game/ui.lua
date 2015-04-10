local Class = require "lib.hump.class"
local Button = require "classes.button"
local Theme = require "assets.theme"
local Gamestate = require "lib.hump.gamestate"
local Rooms = require "states.game.rooms"

local ui = Class {
  init = function (self)
    self.verbs = {
      "Give",
      "Pick Up",
      "Use",
      "Open",
      "Look at",
      "Push",
      "Close",
      "Talk to",
      "Pull"
    }
    self.defaultVerb = { Room = "Walk to", Inventory = "Look at" }
    self.verbResetTimer = 0
    
    self.game = nil --since this is a singleton specifically for one state, might as well refer to the one state :) - the state will need to set it though
    
    self:createVerbUI()
    self:wireVerbKeys()
  end
}

ui.mouseZones = {
  Room = 1,
  Verbs = 2,
  UpDown = 3,
  Inventory = 4,
  VerbLine = 5
}

--Setup
function ui:createVerbUI()
  self.verbButtons = {}
  local origin = { x = 0, y = 520 }
  local pad, h, w = 5, 60, 180
  local row = 1
  
  for i, v in pairs(self.verbs) do
    local col = i - ((row-1) * 3)
    local x = origin.x + ((col-1) * w) + (col * pad)
    local y = origin.y + ((row-1) * h) + (row * pad)
    
    self.verbButtons[i] = Button(
      self.verbs[i],
      x, y, w, h,
      function () self.game.verb = self.verbs[i] end)
    
    if i % 3 == 0 then row = row + 1 end
  end
end
function ui:wireVerbKeys()
  self.verbKeys = {}
  
  for i, v in pairs(self.verbs) do
    local key
    if v == "Push" then key = "s"
    elseif v == "Pull" then key = "y"
    else key = v:sub(1,1):lower() end
    
    self.verbKeys[key] = i
  end
end

-- Drawing
function ui:drawVerbUI ()
  for _, v in ipairs(self.verbButtons) do
    v:draw()
  end
end

function ui:drawVerbLine ()
  local verbLine = self.executingVerbLine or
    (self.game.verb == "Default" and self:getDefaultVerb() or self.game.verb)
    .. " " ..
    (self.game.object and self.game.object.name or "")
  
  
  love.graphics.setColor(self.executingVerbLine and Theme.colors.verbLine.executing or Theme.colors.verbLine.normal)
  love.graphics.setFont(Theme.fonts.verbLine)
  
  love.graphics.printf(
    verbLine,
    0, 505, love.window.getWidth(), "center")
end

--Handlers
function ui:handleVerbKeys(key)
  if self.verbKeys[key] then
    self.verbButtons[self.verbKeys[key]]:execute()
  end
end

function ui:handleMousePress(x, y, button)
  local zone = self:getMouseZone()
  
  --left or right, no matter, set the verb
  if zone == self.mouseZones.Verbs
  then return self:handleVerbButtons() end
  
  if zone == self.mouseZones.UpDown
  then return self:handleUpDownButtons() end
  
  if button == "r" then
    self:handleObjectDefault()
  end
  
  if zone == self.mouseZones.Room or zone == self.mouseZones.Inventory
  then self.game:executeVerbLine() end
end

function ui:handleMouseMove(x, y)
  
  local hoverHandled = false
  --handle inventory hover
  if self:getMouseZone() == self.mouseZones.Inventory then
    hoverHandled = self:handleInventoryHover()
  end
  
  --handle room object/actor hover
  if self:getMouseZone() == self.mouseZones.Room then
    hoverHandled = self:handleRoomObjectHover()
    if self:handleActorHover() then hoverHandled = true end --actor hover overrides object hover, but doesn't cancel it!
  end
  
  --handle mouseOut (i.e. hovering over nothing)
  if not hoverHandled then self.game.object = nil end
  return
end

function ui:handleVerbButtons()
  for _, v in ipairs(self.verbButtons) do
    if v:isPressed() then v:execute() end    
  end
end

function ui:handleInventoryHover()
  for _, v in ipairs(self.game.inventory.buttons) do
    if v:isHover() then v:execute(); return true end    
  end
  return false
end

function ui:handleRoomObjectHover()
  for _, v in ipairs(Rooms.current().objects) do
    if v:isHover() then self.game.object = v; return true end    
  end
  return false
end

function ui:handleActorHover()
  return false
end

function ui:handleUpDownButtons()
  if self.game.inventory.upbutton:isPressed() then self.game.inventory.upbutton:execute() end
  if self.game.inventory.downbutton:isPressed() then self.game.inventory.downbutton:execute() end
end

function ui:handleObjectDefault()
  if not self.game.object then return end
  if self:getMouseZone() == self.mouseZones.Inventory then
    self.game.verb = "Default"
  else
    self.game.verb = self.game.object.defaultVerb
  end
end

--Helpers
function ui:getDefaultVerb()
  if self:getMouseZone() == self.mouseZones.Inventory then
    return self.defaultVerb.Inventory
  else
    return self.defaultVerb.Room
  end
end

function ui:getMouseZone()
  if love.mouse.getY() < 500 then return self.mouseZones.Room end
  if love.mouse.getY() < 525 then return self.mouseZones.VerbLine end
  
  if love.mouse.getX() < 560 then return self.mouseZones.Verbs end
  if love.mouse.getX() > 610 then return self.mouseZones.Inventory end
  return self.mouseZones.UpDown
end

function ui:resetVerbLine(dt)
  if not self.executingVerbLine then return end
  if self.verbResetTimer <= 0 then
    self.executingVerbLine = nil
    return
  end
  self.verbResetTimer = self.verbResetTimer - dt
end

function ui:executeVerbLine(time)
  self.executingVerbLine =
    (self.game.verb == "Default" and self:getDefaultVerb() or self.game.verb)
    .. " " ..
    (self.game.object and self.game.object.name or "")
  
  self.verbResetTimer = time or 1
end
  
return ui()