local Class = require "lib.hump.class"
local Theme = require "assets.theme"
local Utils = require "classes.utils"

local highlit = false --use getters and setters on this one

local button = Class {
  init = function (self, content, x, y, w, h, action)
    self.x = x
    self.y = y
    self.width = w
    self.height = h
    
    if action then
      self.active = true
    else
      self.active = false
    end
    
    self.execute = function (self)
      if self.active then
        if action then action() end
      end
    end
    
    self.content = content
  end
}

button.States = {
  normal = 1,
  hover = 2,
  pressed = 3,
  disabled = 4,
  highlit = 5
}

button.Colors = {
  back = {
    [button.States.normal] = Theme.colors.button.back.normal,
    [button.States.hover] = Theme.colors.button.back.hover or Theme.colors.button.back.normal,
    [button.States.pressed] = Theme.colors.button.back.pressed or Theme.colors.button.back.normal,
    [button.States.disabled] = Theme.colors.button.back.disabled or Theme.colors.button.back.normal,
    [button.States.highlit] = Theme.colors.button.back.highlit or Theme.colors.button.back.hover
  },
  text = {
    [button.States.normal] = Theme.colors.button.text.normal,
    [button.States.hover] = Theme.colors.button.text.hover or Theme.colors.button.text.normal,
    [button.States.pressed] = Theme.colors.button.text.pressed or Theme.colors.button.text.normal,
    [button.States.disabled] = Theme.colors.button.text.disabled or Theme.colors.button.text.normal,
    [button.States.highlit] = Theme.colors.button.text.highlit or Theme.colors.button.text.hover
  }
}

function button:isHover(x, y)
  return Utils.isHover(self, x, y)
end

function button:isPressed()
  return self:isHover()
  and (love.mouse.isDown("l") or love.mouse.isDown("r"))
end

function button:isActive()
  return self.active
end

function button:isHighlit()
  return highlit
end

function button:highlight()
  highlit = true
end
function button:lowlight()
  highlit = false
end

function button:getState()
  if not self:isActive() then return button.States.disabled end
  if self:isHighlit() then return button.States.highlit end
  if self:isPressed() then return button.States.pressed end
  if self:isHover() then return button.States.hover end
  return button.States.normal
end

function button:draw()
  local colors = self.colors or button.Colors --use own override colors, or the theme
  
  --draw button
  love.graphics.setColor(colors.back[self:getState()]) --set colors by state
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
  
  
  --draw content
  if not self.content then return end
  if type(self.content) == "string" then
    love.graphics.setColor(colors.text[self:getState()])
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