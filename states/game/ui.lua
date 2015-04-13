local Class = require "lib.hump.class"
local InventoryUI = require "states.game.ui.inventory"
local VerbUI = require "states.game.ui.verbs"
local VerblineUI = require "states.game.ui.verbline"

local ui = Class {
  
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
function ui:keypressed(key)
  VerbUI:keypressed(key)
end

function ui:inventoryChanged()
  InventoryUI:inventoryChanged()
end

-- Helpers
function ui:getZone(x, y)
  --hit test each UI zone
  if VerbUI.zone:isHover(x, y) then return self.Zones.Verbs end
  if InventoryUI.zone:isHover(x, y) then return self.Zones.Inventory end
  if InventoryUI.zoneUpDown:isHover(x, y) then return self.Zones.UpDown end
  if VerblineUI.zone:isHover(x, y) then return self.Zones.UpDown end
  
  return self.Zones.Room --no defined UI zone, must be the room
end

return ui()