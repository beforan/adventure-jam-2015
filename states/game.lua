local game = {}

local Actor = require "classes.actor"
local RT = require "states.game.runtime"
local Theme = require "assets.theme"

function game:init()
  self.player = Actor()
  self.player:setPos({ x = 40, y = 300 })
end

function game:update(dt)
  self.player:update(dt)
end

function game:draw()
  self.player:draw()
  
  self:drawDebug()
end

function game:mousepressed(x, y, button)
  RT:verbWalkto({ x = x, y = y })
end

-- helpers
function game:drawDebug()
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.setFont(Theme.fonts.verbLine)
  love.graphics.print(love.mouse.getX() .. "," .. love.mouse.getY())
  --love.graphics.printf(Rooms.current().name, 0, 0, love.window.getWidth(), "center")
  love.graphics.print(self.player.x .. "," .. self.player.y, 150)
end

return game