local Class = require "lib.hump.class"
local Button = require "classes.button"
local Theme = require "assets.theme"
local Gamestate = require "lib.hump.gamestate"
local Rooms = require "states.game.rooms"

local ui = Class {
  init = function (self)
    self.verbResetTimer = 0
  end
}

function ui:handleObjectDefault()
  if not self.game.object then return end
  if self:getMouseZone() == self.mouseZones.Inventory then
    self.game.verb = "Default"
  else
    self.game.verb = self.game.object.defaultVerb
  end
end

--Helpers
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