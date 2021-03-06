local Class = require "lib.hump.class"
local Gamestate = require "lib.hump.gamestate"

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
  if not Gamestate.current().blocking then
    VerbUI:draw()
    InventoryUI:draw()
  end
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
  if not hoverHandled then game.hovered = nil end
end

function ui:mousepressed(game, x, y, button)
  local zone = self:getZone(x, y)
  
  --left or right, no matter, set the verb
  if zone == self.Zones.Verbs
  then VerbUI:mousepressed(x, y, button) end
  
  if zone == self.Zones.UpDown
  then return InventoryUI:mousepressed(x, y, button) end
  
  if button == 2 then
    self:handleObjectDefault(game)
  end
  
  if zone == self.Zones.Room or zone == self.Zones.Inventory then
    game:execute(x, y)
    VerblineUI.holdTimer = 0.5
  end
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
  for _, v in ipairs(Rooms.current().actors) do
    if v:isHover(x, y) then
      game.hovered = v
      return true
    end
  end
  
  for _, v in ipairs(Rooms.current().objects) do
    if v:isHover(x, y) then
      game.hovered = v
      return true
    end
  end
  return false
end

function ui:handleObjectDefault(game)
  if not game.hovered then return end
  if self:getZone() == self.Zones.Room then
    game:prepVerb(game:getVerb(game.hovered.defaultVerb))
  end
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