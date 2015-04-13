local Class = require "lib.hump.class"

local InventoryUI = require "states.game.ui.inventory"
local VerbUI = require "states.game.ui.verbs"
local VerblineUI = require "states.game.ui.verbline"
local Rooms = require "states.game.rooms"

local ui = Class {
  init = function (self)
    
  end
}

ui.Zones = {
  Room = 1,
  Verbs = 2,
  UpDown = 3,
  Inventory = 4,
  VerbLine = 5
}

function ui:update(dt)
  InventoryUI:update()
  VerbUI:update()
  VerblineUI:update(dt)
end

function ui:draw()
  VerbUI:draw()
  InventoryUI:draw()
  VerblineUI:draw()
end

-- "callbacks"
function ui:mousemoved(game, x, y)
  
  --check for hover within the UI
  local hoverHandled = false
  local zone = self:getZone(x, y)
  if zone == self.Zones.Inventory then
    hoverHandled = InventoryUI:mousemoved(x, y)
  end
  
  if zone == self.Zones.Room then
    hoverHandled = self:handleRoomHover(game, x, y)
  end
  
  --handled "mouse out" (i.e. hovering over nothing)
  if not hoverHandled then game.target = nil end
end

function ui:mousepressed(x, y, button)
  local zone = self:getZone(x, y)
  
  --left or right, no matter, set the verb
  if zone == self.Zones.Verbs
  then return VerbUI:mousepressed(x, y, button) end
  
  if zone == self.Zones.UpDown
  then return InventoryUI:mousepressed(x, y, button) end
  
  --if button == "r" then
  --  self:handleObjectDefault()
  --end
  
  --if zone == self.mouseZones.Room or zone == self.mouseZones.Inventory
  --then self.game:executeVerbLine() end
end

function ui:keypressed(key)
  VerbUI:keypressed(key)
end

function ui:inventoryChanged()
  InventoryUI:inventoryChanged()
end

-- Handlers
function ui:handleRoomHover(game, x, y)
  --actors take priority over objects
  --check each actor
  
  for _, v in ipairs(Rooms.current().objects) do
    if v:isHover(x, y) then
      game.target = v
      return true
    end
  end
  return false
end

-- Helpers
function ui:getZone(x, y)
  --hit test each UI zone
  if VerbUI.zone:isHover(x, y) then return self.Zones.Verbs end
  if InventoryUI.zone:isHover(x, y) then return self.Zones.Inventory end
  if InventoryUI.zoneUpDown:isHover(x, y) then return self.Zones.UpDown end
  if VerblineUI.zone:isHover(x, y) then return self.Zones.VerbLine end
  
  return self.Zones.Room --no defined UI zone, must be the room
end

return ui()