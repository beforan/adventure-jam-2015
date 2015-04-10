local Class = require "lib.hump.class"
local Theme = require "assets.theme"

local actor = Class {
  init = function (self)
    self.name = "Guybrush"
    self.x = 0
    self.y = 0
    self.speech = ""
    self.speechtimer = 0
    self.textcolor = { 120, 120, 0, 255 }
    self.target = { x = -1, y = -1 }
  end
}

function actor:loseTarget()
  self.target = { x = -1, y = -1 }
end

function actor:speak(text)
  self.speechtimer = 0.5 --min
  for char in text:gmatch(".") do
    self.speechtimer  = self.speechtimer + 0.05 --seconds per character?
  end
  
  self.speech = text
end

function actor:draw()
  self:drawBody()
  self:drawSpeech()
end

function actor:update(dt)
  if self.speechtimer > 0 then self.speechtimer = self.speechtimer - dt end
  
  local speed = 50
  
  --movement
  if self.target.x > -1 and self.target.y > -1 then
    if self.x < self.target.x then self.x = self.x + math.round(speed * dt) end
    if self.x > self.target.x then self.x = self.x - math.round(speed * dt) end
    if self.y < self.target.y then self.y = self.y + math.round(speed * dt) end
    if self.y > self.target.y then self.y = self.y - math.round(speed * dt) end
  end
end

function actor:drawBody()
  love.graphics.setColor(0,0,0,255)
  love.graphics.rectangle("fill", self.x - 10, self.y - 10, 20, 20)
end

function actor:drawSpeech()
  if self.speechtimer <= 0 then return end
  
  local font = Theme.fonts.actorSpeak
  local w, lines = font:getWrap(self.speech, 400) --approx 1280/3
  local align = "center" --default to center
  
  --setup x within window bounds
  local x = self.x - w / 2
  if x < 5 then x = 5; align = "left" end
  if x + w > 1275 then x = 1275 - w; align = "right" end
  --setup y within window bounds
  local y = self.y - 150 - (lines * font:getHeight()) --TODO: 150 is arbitrary - will need adjusting based on sprite height
  if y < 5 then y = 5 end
  if lines > 1 then align = "center" end --always center if wrapping
  
  love.graphics.setFont(font)
  love.graphics.setColor(0, 0, 0, 255)
  love.graphics.printf(self.speech, x+2, y+2, w, align)
  love.graphics.setColor(self.textcolor)
  love.graphics.printf(self.speech, x, y, w, align)
end

return actor