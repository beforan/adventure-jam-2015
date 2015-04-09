local Class = require "lib.hump.class"
local Gamestate = require "lib.hump.gamestate"

local object = Class {
  init = function (self, param)
    if type(param) == "string" then --just the name passed in
      self.name = param
      self.defaultVerb = "Look at"
      self.x = 0
      self.y = 0
    end
    
    if type(param) == "table" then --build from an object spec table
      self.name = param.name or ""
      self.x = param.x or 0
      self.y = param.y or 0
      
      --potentially set these off the image when that's working?
      self.width = param.width or 20
      self.height = param.height or 20
      
      --overrides, if present in the spec
      self.defaultVerb = param.defaultVerb or "Look at"
      if param.noop then self.noop = param.noop end
      if param.lookat then self.lookat = param.lookat end
      if param.give then self.give = param.give end
      if param.talkto then self.talkto = param.talkto end
      if param.open then self.open = param.open end
      if param.close then self.close = param.close end
      if param.push then self.push = param.push end
      if param.param then self.pull = param.pull end
      if param.use then self.use = param.use end
      if param.pickup then self.pickup = param.pickup end
      if param.draw then self.draw = param.draw end
    end
  end
}

function object:isHover()
  return isHover(self)
end

function object:noop()
  Gamestate.current().player:speak("That doesn't seem to work.")
end

function object:lookat()
  Gamestate.current().player:speak("An object.")
end

function object:give()
  self:noop()
end

function object:talkto()
  self:noop()
end

function object:open()
  self:noop()
end

function object:close()
  self:noop()
end

function object:push()
  self:noop()
end

function object:pull()
  self:noop()
end

function object:use()
  self:noop()
end

function object:pickup()
  self:noop()
end

--for drawing in rooms
function object:draw()
  love.graphics.setColor(50,50,50,255)
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

return object