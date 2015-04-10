local stGame = {}

local Theme = require "assets.theme"
local Settings = require "settings"
local Button = require "classes.button"
local Object = require "classes.object"
local Actor = require "classes.actor"
local Inventory = require "classes.inventory"

local UI = require "states.game.ui"
local Rooms = require "states.game.rooms"


function stGame:init()
  UI.game = self --take ownership of the UI
  
  self.verb = "Default"
  
  --initialise the player actor
  self.player = Actor()
  self.player.x = 40
  self.player.y = 300
  
  --initialise inventory
  self.inventory = Inventory()
  self.inventory.items = {}
  self.inventory:updateButtons()
  
  --handle room stuff sometime
  Rooms.switch("test")
end

function stGame:update(dt)
  if not self.blocking then
    UI:resetVerbLine(dt)
  end
  
  if self.executing then
    self.executing.object[self.executing.verb](self.executing.object)
  end
  
  self.player:update(dt)
end

function stGame:draw()
  Rooms.current():draw()
  
  --the actual UI
  UI:drawVerbLine()
  if not self.blocking then
    UI:drawVerbUI()
    
    --the inventory (draws itself, even though this is UI...)
    self.inventory:draw()
  end
  
  --draw the player
  self.player:draw()
  
  --draw any debug information from the state
  self:drawDebug()
end

--Callbacks
function stGame:keypressed(key)
  if not self.blocking then
    --handle verb shortcuts
    UI:handleVerbKeys(key)
  end
  
  --any other keys?
  if Settings.debug then --debug keys
    if key == 'r' then Rooms.resetRoom() end
  end
end

function stGame:mousepressed(x, y, button)
  if not self.blocking then
    UI:handleMousePress(x,y, button)
  end
end

function stGame:mousemoved(x, y)
  if not self.blocking then
    UI:handleMouseMove(x, y)
  end
end

--helpers
function stGame:drawDebug()
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.setFont(Theme.fonts.verbLine)
  love.graphics.print(love.mouse.getX() .. "," .. love.mouse.getY())
end

function stGame:executeVerbLine()  
  self.player:loseTarget()
  self.executing = nil
  
  if self.verb == "Default" then
    self.verb =
      UI:getMouseZone() == UI.mouseZones.Inventory and UI.defaultVerb.Inventory
      or UI.defaultVerb.Room
  end
  
  --is there an object?
  if self.object then
    if self.verb == "Walk to" then
      self.player.target = { x = self.object.useposition.x or self.object.x, y = self.object.useposition.y or self.object.y }
    else
      self.executing = { verb = self.verb:gsub(" ", ""):lower(), object = self.object }
    end
    --fix the verbLine for a while
    UI:executeVerbLine(self.object.executeTime)
  else
    --handle arbitrary walk to
    if self.verb == "Walk to" then
      self.player.target = { x = love.mouse.getX(), y = love.mouse.getY() }
      --fix the verbLine for a while
      UI:executeVerbLine(0.3)
    end
    
    --any other verb should cancel without an object
  end
  
  --reset
  self.verb = "Default"
  self:mousemoved(love.mouse.getX(), love.mouse.getY()) --use this to reset object hover?
end

return stGame