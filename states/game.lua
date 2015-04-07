local stGame = {}

local Theme = require "assets.theme"
local Button = require "classes.button"
local Object = require "classes.object"

function stGame:init()
  self.mouseZones = {
    Room = 1,
    Verbs = 2,
    UpDown = 3,
    Inventory = 4,
    VerbLine = 5
  }
  
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
  
  self.verbKeys = self:wireVerbKeys()
  self.verbButtons = self:createVerbUI()
  
  self.defaultVerb = { Room = "Walk to", Inventory = "Look at" }
  self.verb = "Default"
  self.object = Object("terrified hamster")
  
  self.Inventory = {
    Object("Hat"),
    Object("Coat"),
    Object("Chair"),
    Object("Face")
  }
  
end

--helpers
function stGame.drawRoom ()
  love.graphics.setColor(180, 0, 0, 255)
  love.graphics.rectangle("fill", 0, 0, 1280, 500)
end

function stGame:drawVerbLine ()
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.setFont(Theme.fonts.verbLine)
  
  love.graphics.printf(
    (self.verb == "Default" and self:getDefaultVerb() or self.verb)
    .. " " ..
    (self.object and self.object.name or ""),
    0, 505, love.window.getWidth(), "center")
end


function stGame:createVerbUI()
  local verbButtons = {}
  local origin = { x = 0, y = 520 }
  local pad, h, w = 5, 60, 180
  local row = 1
  
  for i, v in pairs(self.verbs) do
    local col = i - ((row-1) * 3)
    local x = origin.x + ((col-1) * w) + (col * pad)
    local y = origin.y + ((row-1) * h) + (row * pad)
    
    verbButtons[i] = Button(
      self.verbs[i],
      x, y, w, h,
      function () self.verb = self.verbs[i] end)
    
    if i % 3 == 0 then row = row + 1 end
  end
  
  return verbButtons
end

function stGame:wireVerbKeys()
  local verbKeys = {}
  
  for i, v in pairs(self.verbs) do
    local key
    if v == "Push" then key = "s"
    elseif v == "Pull" then key = "y"
    else key = v:sub(1,1):lower() end
    
    verbKeys[key] = i
  end
  
  return verbKeys
end

function stGame:drawVerbUI ()
  for _, v in ipairs(self.verbButtons) do
    v:draw()
  end
end

function stGame:draw()
  self.drawRoom()
  
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.setFont(Theme.fonts.verbLine)
  love.graphics.print(love.mouse.getX() .. "," .. love.mouse.getY())
  
  self:drawVerbLine()
  self:drawVerbUI()
end

function stGame:update()
  
end

function stGame:keypressed(key)
  --handle verb shortcuts
  if self.verbKeys[key] then
    self.verbButtons[self.verbKeys[key]]:execute()
  end
  
  --any other keys?
end

function stGame:mousemoved(x, y)
  
  
end

function stGame:getDefaultVerb()
  if self:getMouseZone() == self.mouseZones.Inventory then
    return self.defaultVerb.Inventory
  else
    return self.defaultVerb.Room
  end
end

function stGame:mousepressed(x, y, button)
  local zone = self:getMouseZone()
  
  --left or right, no matter, set the verb
  if zone == self.mouseZones.Verbs
  then return self:handleVerbButtons() end
  
  if zone == self.mouseZones.UpDown
  then return end --TODO: UpDown handler later
  
  if button == "r" then
    self:handleObjectDefault()
  end
  
  if zone == self.mouseZones.Room or zone == self.mouseZones.Inventory
  then self:executeVerbLine() end
  
end

function stGame:getMouseZone()
  if love.mouse.getY() < 500 then return self.mouseZones.Room end
  if love.mouse.getY() < 525 then return self.mouseZones.VerbLine end
  
  if love.mouse.getX() < 560 then return self.mouseZones.Verbs end
  if love.mouse.getX() > 610 then return self.mouseZones.Inventory end
  return self.mouseZones.UpDown
end

function stGame:handleVerbButtons()
  for _, v in ipairs(self.verbButtons) do
    if v:isPressed() then v:execute() end    
  end
end

function stGame:handleObjectDefault()
  if not self.object then return end
  if self:getMouseZone() == self.mouseZones.Inventory then
    self.verb = "Default"
  else
    self.verb = self.object.defaultVerb
  end
end

function stGame:executeVerbLine()  
  if self.verb == "Default" then
    self.verb =
      self:getMouseZone() == self.mouseZones.Inventory and self.defaultVerb.Inventory
      or self.defaultVerb.Room
  end
  
  self.verb = "Default"
  self.object = nil
  return true
end

return stGame