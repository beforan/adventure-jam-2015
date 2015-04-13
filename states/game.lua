local game = {}

local Signals = require "lib.hump.signal"

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
  
  self.verb = nil
  self.target = nil
    
  --[[self.executing = {
    verb = nil,
    target = nil,
    target2 = nil,
    ["type"] = nil,
    script = nil
  }--]]
  
  self:switchPlayer(Actor())
  self.player:setPos({ x = 40, y = 300 })
  
  --handle room stuff sometime
  Rooms.switch("test")
end

function game:enter()
  
end

function game:update(dt)
  if self.player.inventory:count() == 0 then
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
    self.player.inventory:add(Object("hat"))
    self.player.inventory:add(Object("dog"))
    self.player.inventory:add(Object("cat"))
    self.player.inventory:add(Object("log"))
  end
  
  self.player:update(dt)
  
  UI:update(dt)
end

function game:draw()
  Rooms.current():draw()
  
  self.player:draw()
  
  UI:draw()
  
  self:drawDebug()
end

-- Callbacks
function game:mousepressed(x, y, button)
  UI:mousepressed(x, y, button)
end

function game:keypressed(key)
  UI:keypressed(key)
end

function game:mousemoved(x, y)
  UI:mousemoved(self, x, y)
end

-- Helpers
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
  love.graphics.print(self.player.x .. "," .. self.player.y, 150)
end

return game