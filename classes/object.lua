local Class = require "lib.hump.class"
local Gamestate = require "lib.hump.gamestate"
local Utils = require "classes.utils"
local RT = require "states.game.runtime"

local object = Class {
  init = function (self, param)
    self.type = "object"
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
      if param.verbBad then self.verbBad = param.verbBad end
      if param.verbWalkto then self.verbWalkto = param.verbWalkto end
      if param.verbLookat then self.verbLookat = param.verbLookat end
      if param.verbGive then self.verbGive = param.verbGive end
      if param.verbTalkto then self.verbTalkto = param.verbTalkto end
      if param.verbOpen then self.verbOpen = param.verbOpen end
      if param.verbClose then self.verbClose = param.verbClose end
      if param.verbPush then self.verbPush = param.verbPush end
      if param.verbPull then self.verbPull = param.verbPull end
      if param.verbUse then self.verbUse = param.verbUse end
      if param.verbPickup then self.verbPickup = param.verbPickup end
      if param.draw then self.draw = param.draw end
      
      self.usepos = param.usepos
    end
    
    
  end
}

--helpers
function object:isHover(x, y)
  return Utils.isHover(self, x, y)
end

--verbs
function object:verbBad()
  RT:player():say("That doesn't seem to work")
end

function object:verbWalkto()
  local player = RT:player()
  RT:walkactor(player, self)
  while player:isMoving() do
    coroutine.yield()
  end
  
  print("arrived")
end

function object:verbLookat()
  RT:player():say("An object.")
end

function object:verbGive()
  self:verbBad()
end

function object:verbTalkto()
  self:verbBad()
end

function object:verbOpen()
  self:verbBad()
end

function object:verbClose()
  self:verbBad()
end

function object:verbPush()
  self:verbBad()
end

function object:verbPull()
  self:verbBad()
end

function object:verbUse()
  self:verbBad()
end

function object:verbPickup()
  if RT:player().inventory:contains(self) then
    RT:player():say("I'm already carrying that.")
  else
    self:verbBad()
  end
end

--for drawing in rooms
function object:draw()
  love.graphics.setColor(50,50,50,255)
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

return object