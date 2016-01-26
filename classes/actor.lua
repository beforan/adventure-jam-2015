local Class = require "lib.hump.class"
local Utils = require "classes.utils"
local RT = require "states.game.runtime"
local Theme = require "assets.theme"
local Inventory = require "classes.inventory"

local actor = Class {
  init = function (self, param)
    self.type = "actor"
    self.name = param.name or param
    
    self.x = param.x or 0
    self.y = param.y or 0
    --potentially set these off the image when that's working?
    self.width = param.width or 20
    self.height = param.height or 20
    
    self.color = param.color or { 120, 120, 0, 255 }
    self.speech = ""
    
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
    
    self.scripts = param.scripts or {}
    self.inventory = Inventory()
    if param.inventory then
      for _, v in param.inventory do
        self.inventory:add(v)
      end
    end
  end
}

function actor:update(dt)
  --anonymous scripts
  for i, v in ipairs(self.scripts) do
    if not coroutine.resume(v, self, dt) then -- run the coroutine this frame
      table.remove(self.scripts, i) -- remove it if it's in a dead state
    end
  end
  --named scripts
  for k, v in pairs(self.scripts) do
    if not coroutine.resume(v, self, dt) then -- run the coroutine this frame
      self.scripts[k] = nil -- remove it if it's in a dead state
    end
  end
end

function actor:draw()
  self:drawBody()
  self:drawSpeech()
end
function actor:drawBody()
  love.graphics.setColor(self.color)
  love.graphics.rectangle("fill", self.x, self.y, 20, 20)
end
function actor:drawSpeech()
  if self.speech == "" then return end
  
  local font = Theme.fonts.actorSpeak
  local w, lines = font:getWrap(self.speech, 400) --approx 1280/3
  local align = "center" --default to center
  
  --setup x within window bounds
  local x = self.x - w / 2
  if x < 5 then x = 5; align = "left" end
  if x + w > 1275 then x = 1275 - w; align = "right" end
  --setup y within window bounds
  local y = self.y - 150 - (#lines * font:getHeight()) --TODO: 150 is arbitrary - will need adjusting based on sprite height
  if y < 5 then y = 5 end
  if #lines > 1 then align = "center" end --always center if wrapping
  
  love.graphics.setFont(font)
  love.graphics.setColor(0, 0, 0, 255)
  love.graphics.printf(self.speech, x+2, y+2, w, align)
  love.graphics.setColor(self.color)
  love.graphics.printf(self.speech, x, y, w, align)
end

function actor:setPos(pos_x, y)
  local pos = y and { x = pos_x, y = y } or pos_x
  self.x = pos.x
  self.y = pos.y
end

function actor:moveTo(pos_x, y)
  local pos = y and { x = pos_x, y = y } or pos_x
  self:stop()
  self.scripts.move = coroutine.create(self.move)
  coroutine.resume(self.scripts.move, self, love.timer.getDelta(), pos)
end
function actor:stop()
  --remove reference to the old movement coroutine, and it won't run next frame!
  self.scripts.move = nil
end

function actor:say(text)
  self:shutUp()
  self.scripts.say = coroutine.create(self.talk)
  coroutine.resume(self.scripts.say, self, love.timer.getDelta(), text)
end
function actor:shutUp()
  self.scripts.say = nil
end


-- helpers
function actor:pickup(item)
  self.inventory:add(item)
end
function actor:drop(item)
  self.inventory:remove(item)
end

-- status
function actor:isMoving()
  return self.scripts.move ~= nil
end

function actor:isTalking()
  return self.scripts.say ~= nil
end


-- coroutines
function actor:move(dt, pos)
  local speed = 50
  while self.x ~= pos.x or self.y ~= pos.y do
    if self.x < pos.x then self.x = self.x + math.round(speed * dt) end
    if self.x > pos.x then self.x = self.x - math.round(speed * dt) end
    if self.y < pos.y then self.y = self.y + math.round(speed * dt) end
    if self.y > pos.y then self.y = self.y - math.round(speed * dt) end
    self, dt = coroutine.yield()
  end
end

function actor:talk(dt, text)
  local timer = 0.5
  for char in text:gmatch(".") do
    timer = timer + 0.05 --seconds per character?
  end
  self.speech = text
  
  while timer > 0 do
    timer = timer - dt
    --animation updates could go here
    coroutine.yield()
  end
  
  self.speech = ""
end

--helpers
function actor:isHover(x, y)
  return Utils.isHover(self, x, y)
end

--verbs
function actor:verbBad()
  RT:player():say("I don't think they'd like that.")
end

function actor:verbWalkto()
  local player = RT:player()
  RT:walkactor(player, self)
  while player:isMoving() do
    coroutine.yield()
  end
end

function actor:verbLookat()
  RT:player():say("A person.")
end

function actor:verbGive()
  self:verbBad()
end

function actor:verbTalkto()
  self:verbBad()
end

function actor:verbOpen()
  self:verbBad()
end

function actor:verbClose()
  self:verbBad()
end

function actor:verbPush()
  self:verbBad()
end

function actor:verbPull()
  self:verbBad()
end

function actor:verbUse()
  self:verbBad()
end

function actor:verbPickup()
  self:verbBad()
end

return actor