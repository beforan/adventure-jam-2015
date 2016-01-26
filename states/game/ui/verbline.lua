local Class = require "lib.hump.class"
local Hotspot = require "classes.hotspot"
local Theme = require "assets.theme"
local Gamestate = require "lib.hump.gamestate"

local ui = Class {
  init = function (self)
    self.zone = Hotspot(0,500, love.graphics.getWidth(), love.graphics.getHeight())
    self.text = ""
    self.holdTimer = 0
    
    self.conjunction = {
      Give = " to ",
      Use = " with "
    }
  end
}

function ui:update(dt)
  local game = Gamestate.current()
  
  -- determine how we're building the verb line
  local source = ""
  if game.executing and game.executing.script then
    source = "exec"
  elseif not game.prep.verb then
    source = "none"
  else
    source = "prep"
  end
  
  if source == "prep" then
    if game.prep.incomplete then
      self.text = 
        game.prep.verb.name
        .. " " ..
        (game.prep.target and game.prep.target.name
        .. (self.conjunction[game.prep.verb.name] or "") or "") ..
        (game.hovered and game.hovered.name or "")
    end
  end
  
  if source == "exec" then
    self.hold = true
    self.holdTimer = 0 --don't need this if we're in exec hold
    self.text = 
      game.executing.verb.name
      .. " " ..
      game.executing.target.name
    
    if game.executing.target2 then
      self.text = self.text .. (self.conjunction[game.executing.verb.name] or "") ..
        game.executing.target2.name
    end
  end
  
  if source == "none" then
    --timer hold check
    self.hold = self.holdTimer > 0
    if self.hold then
      self.holdTimer = self.holdTimer - dt
      
      --use exec, just not based on an ongoing script
      -- e.g. walk to / verb with no param
      self.text = game.executing.verb.name
    else
      self.text =
        game:getDefaultVerb().name
        .. (game.hovered and (" " .. game.hovered.name) or "")
    end
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