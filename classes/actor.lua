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
  end
}

function actor:speak(text)
  self.speechtimer = 0.5 --min
  for char in text:gmatch(".") do
    self.speechtimer  = self.speechtimer + 0.05 --seconds per character?
  end
  
  self.speech = text
end

function actor:draw()
  --self:drawBody()
  self:drawSpeech()
end

function actor:update(dt)
  if self.speechtimer > 0 then self.speechtimer = self.speechtimer - dt end
end

function actor:drawSpeech()
  if self.speechtimer <= 0 then return end
  
  local w = 400 --approx 1280/3
  
  --setup x within window bounds
  local x = self.x - w / 2
  if x < 0 then x = 0 end
  if x + w > 1280 then x = 1280 - w end
  --setup y within window bounds
  local y = self.y - 150 --not sure how we'll do this for real... need to know if we've wrapped, and how many lines
  
  love.graphics.setFont(Theme.fonts.actorSpeak)
  love.graphics.setColor(0, 0, 0, 255)
  love.graphics.printf(self.speech, x+2, y+2, w, "center") --single line should be left or right if not wrapping...
  love.graphics.setColor(self.textcolor)
  love.graphics.printf(self.speech, x, y, w, "center") --single line should be left or right if not wrapping...
end

return actor