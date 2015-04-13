local Class = require "lib.hump.class"
local Hotspot = require "classes.hotspot"
local Theme = require "assets.theme"
local Gamestate = require "lib.hump.gamestate"

local ui = Class {
  init = function (self)
    self.zone = Hotspot(0,500, love.window.getWidth(), love.window.getHeight())
    self.text = ""
    self.hold = false
  end
}

function ui:update(dt)
  local game = Gamestate.current()
  
  if game.executing then
    --not sure what this will look like yet
    --check type (object/actor vs co-ords)
    --this determines indefinite holding (while executing)
    --or a quick timer
    --this will also include execution setup
    --(e.g. give x to ... is incomplete)
    --for now let's always do the quick timer, like previously
  end
  
  if not game.executing then --or self.holdtimer <= 0 then -- hover / preview mode
    self.hold = false
    self.text =
      (game.current.verb and game.current.verb.name or game:getDefaultVerb().name)
      .. " " ..
      (game.current.target and game.current.target.name or "")
  end
end

function ui:draw()
  local pad = 5
  
  love.graphics.setColor(self.hold and Theme.colors.verbline.hold or Theme.colors.verbline.normal)
  love.graphics.setFont(Theme.fonts.verbline)
  
  love.graphics.printf(
    self.text,
    self.zone.x, self.zone.y + pad,
    self.zone.width, "center")
end

return ui()