local game = {}

local Signals = require "lib.hump.signal"
local Class = require "lib.hump.class"

local Actor = require "classes.actor"
local Verb = require "classes.verb"
local Object = require "classes.object"

local RT = require "states.game.runtime"
local UI = require "states.game.ui"
local Rooms = require "states.game.rooms"
local Theme = require "assets.theme"


function game:init()
  self.verbs = {
    Verb("Give"),
    Verb("Pick up"),
    Verb("Use"),
    Verb("Open"),
    Verb("Look at"),
    Verb("Push", "s"), -- Shove
    Verb("Close"),
    Verb("Talk to"),
    Verb("Pull", "y") -- Yank
  }
  self.defaultVerb = { Room = Verb("Walk to"), Inventory = self.verbs[5] }
  
  self.prep = {}
  
  self:switchPlayer(Actor())
  self.player:setPos(400, 200)
  
  --handle room stuff sometime
  Rooms.switch("test")
end

function game:enter()
  
end

function game:update(dt)
  --[[if self.player.inventory:count() == 0 then
    local o = Object("hat")
    o.useWith = true
    self.player.inventory:add(o)
    self.player.inventory:add(Object("dog"))
    self.player.inventory:add(Object("cat"))
    self.player.inventory:add(Object("log"))
    self.player.inventory:add(Object("hat"))
    self.player.inventory:add(Object("dog"))
    self.player.inventory:add(Object("cat"))
    self.player.inventory:add(Object("log"))
    self.player.inventory:add(Object("hat"))
    self.player.inventory:add(Object("dog"))
    self.player.inventory:add(Object("cat"))
    self.player.inventory:add(Object("log"))
    self.player.inventory:add(Object("hat"))
    self.player.inventory:add(Object("dog"))
    self.player.inventory:add(Object("cat"))
    self.player.inventory:add(Object("log"))
    self.player.inventory:add(Object("hat"))
    self.player.inventory:add(Object("dog"))
    self.player.inventory:add(Object("cat"))
    self.player.inventory:add(Object("log"))
    self.player.inventory:add(Object("hat"))
    self.player.inventory:add(Object("dog"))
    self.player.inventory:add(Object("cat"))
    self.player.inventory:add(Object("log"))
  end--]]
  
  self.player:update(dt)
  
  UI:update(dt)
  
  --keep running the executing coroutine, or tidy up if it's dead
  if self.executing then
    if self.executing.script then
      local success, err = coroutine.resume(
        self.executing.script,
        self.executing.target,
        dt,
        self.executing)
      if not success then
        print(err)
        self.executing.script = nil
      end
    end
  end
end

function game:draw()
  Rooms.current():draw()
  
  self.player:draw()
  
  UI:draw()
  
  self:drawDebug()
end

-- Callbacks
function game:mousepressed(x, y, button)
  if not self.blocking then
    UI:mousepressed(self, x, y, button)
  end
end

function game:keypressed(key)
  if not self.blocking then
    UI:keypressed(key)
  end
end

function game:mousemoved(x, y)
  if not self.blocking then
    UI:mousemoved(self, x, y)
  end
end

-- Helpers
function game:execute(x, y)
  if self.blocking then return end
  
  if self.prep.target then --we already have a target, we must want another
    -- add a second parameter to prep
    self.prep.target2 = self.hovered
    self.prep.incomplete = false
  else
    -- update prep
    if not self.prep.verb then self.prep.verb = self:getDefaultVerb() end
    self.prep.target = self.hovered or { x = x, y = y }
    
    --completion conditions
    if not self.prep.target.type then -- target is a location
      self.prep.incomplete = false
    elseif self.prep.verb ~= game:getVerb("Give") then -- Give requires 2 nouns
      if self.prep.verb ~= game:getVerb("Use")
        or not self.prep.target.useWith then -- Use requires 2 nouns if useWith is true
          self.prep.incomplete = false
      end
    end
  end
  
  if not self.prep.incomplete then
    --convert prep to executing
    self.executing = {} -- cancel any prior execution at this point
    self.executing.verb = self.prep.verb
    self.executing.target = self.prep.target
    self.executing.target2 = self.prep.target2
    
    self.prep = {}
    
    RT:executeVerb(self.executing)
  end
end

function game:prepVerb(verb)
  self.prep = {
    verb = verb,
    incomplete = true
  }
end

function game:getDefaultVerb()
  if UI:getZone() == UI.Zones.Inventory then
    return self.defaultVerb.Inventory
  end
  return self.defaultVerb.Room
end
function game:getVerb(name)
  -- Walk to, which isn't stored in self.verbs
  if name == self.defaultVerb.Room.name then return self.defaultVerb.Room end
  for _, v in ipairs(self.verbs) do
    if name == v.name then return v end
  end
end

function game:switchPlayer(actor)
  if self.player then
    --unregister from old player signals
    self.player.inventory.signals.clear("inventory-changed")
  end
  
  --register new player signals
  actor.inventory.signals.register("inventory-changed", function () UI:inventoryChanged() end)
  
  --switch player
  self.player = actor
end

function game:drawDebug()
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.setFont(Theme.fonts.verbline)
  love.graphics.print(love.mouse.getX() .. "," .. love.mouse.getY())
  --love.graphics.printf(Rooms.current().name, 0, 0, love.window.getWidth(), "center")
  --love.graphics.print(self.player.x .. "," .. self.player.y, 150)
end

return game