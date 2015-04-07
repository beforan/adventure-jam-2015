local Class = require "lib.hump.class"
local Theme = require "assets.theme"

local button = Class {
  init = function (self, content, x, y, w, h, action)
    self.x = x
    self.y = y
    self.width = w
    self.height = h
    self.execute = action
    self.content = content
  end
}

button.States = {
  normal = 1,
  hover = 2,
  pressed = 3
}

function button:isHover()
  local mouse = { x = love.mouse.getX(), y = love.mouse.getY() }
  
  return mouse.x >= self.x and mouse.x < self.x + self.width
    and mouse.y >= self.y and mouse.y < self.y + self.height
end

function button:isPressed()
  return self:isHover()
  and (love.mouse.isDown("l") or love.mouse.isDown("r"))
end

function button:getState()
  if self:isHover() then return button.States.hover end
  if self:isPressed() then return button.States.pressed end
  return button.States.normal
end

function button:draw()
  love.graphics.setColor(self:isHover() and Theme.colors.button.hover.back or Theme.colors.button.normal.back)
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
  
  if type(self.content) == "string" then
    love.graphics.setColor(self:isHover() and Theme.colors.button.hover.text or Theme.colors.button.normal.text)
    love.graphics.setFont(Theme.fonts.verbButton)
    love.graphics.printf(
      self.content,
      self.x,
      self.y + (self.height/2) - (love.graphics.getFont():getHeight() / 2),
      self.width,
      "center")
  end
  
  --TODO: image button content
  
end

return button