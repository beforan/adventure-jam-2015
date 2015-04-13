local Class = require "lib.hump.class"
local Button = require "classes.button"
local RT = require "states.game.runtime"
local Utils = require "classes.utils"
local Hotspot = require "classes.hotspot"
local Gamestate = require "lib.hump.gamestate"

local ui = Class {
  init = function (self)
    self.buttons = {
      pad = 5,
      width = 180,
      height = 60,
      cols = 3,
      rows = 3
    }
    
    self.zone = Hotspot(0, 520,
      self.buttons.width * self.buttons.cols + self.buttons.pad * (self.buttons.cols + 1),
      self.buttons.height * self.buttons.rows + self.buttons.pad * (self.buttons.rows + 1))
  end
}

function ui:createButtons()
  local game = Gamestate.current()
  local row = 1
  
  for i, v in ipairs(game.verbs) do
    local col = i - ((row-1) * self.buttons.cols)
    local x = self.zone.x + ((col-1) * self.buttons.width) + (col * self.buttons.pad)
    local y = self.zone.y + ((row-1) * self.buttons.height) + (row * self.buttons.pad)
    
    self.buttons[i] = Button(
      v.name,
      x, y, self.buttons.width, self.buttons.height,
      function () game.verb = v end)
    
    if i % (self.buttons.cols) == 0 then row = row + 1 end
  end
end

function ui:update()
  if #self.buttons == 0 then
    self:createButtons()
  end
end

function ui:draw()
  for _, v in ipairs(self.buttons) do
    v:draw()
  end
end

function ui:keypressed(key)
  local game = Gamestate.current()
  for _, v in ipairs(game.verbs) do
    if v.key == key then
      game.current.verb = v
      break
    end
  end
end

function ui:mousepressed(x, y, button)
  for _, v in ipairs(self.buttons) do
    if v:isPressed() then v:execute() end    
  end
end

return ui()