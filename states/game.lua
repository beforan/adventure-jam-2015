local stGame = {}

local Theme = require "assets.theme"
local Button = require "classes.button"
local Object = require "classes.object"
local Actor = require "classes.actor"
local Inventory = require "classes.inventory"

local UI = require "states.game.ui"

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
end

function stGame:update(dt)
  self.player:update(dt)
end

function stGame:draw()
  self.drawRoom()
  
  --the actual UI
  UI:drawVerbLine()
  UI:drawVerbUI()
  
  --the inventory (draws itself, even though this is UI...)
  self.inventory:draw()
  
  --draw the player
  self.player:draw()
  
  --draw any debug information from the state
  self:drawDebug()
end

--Callbacks
function stGame:keypressed(key)
  --handle verb shortcuts
  UI:handleVerbKeys(key)
  
  --any other keys?
end

function stGame:mousepressed(x, y, button)
  UI:handleMousePress(x,y, button)
end

function stGame:mousemoved(x, y)
  UI:handleMouseMove(x, y)
end

--helpers
function stGame.drawRoom () --this will go to Room once that's a thing
  love.graphics.setColor(180, 0, 0, 255)
  love.graphics.rectangle("fill", 0, 0, 1280, 500)
end

function stGame:drawDebug()
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.setFont(Theme.fonts.verbLine)
  love.graphics.print(love.mouse.getX() .. "," .. love.mouse.getY())
end

function stGame:executeVerbLine()  
  self.player:loseTarget()
  
  if self.verb == "Default" then
    self.verb =
      UI:getMouseZone() == UI.mouseZones.Inventory and UI.defaultVerb.Inventory
      or UI.defaultVerb.Room
  end
  
  --is there an object?
  if self.object then
    local kVerb = self.verb:gsub(" ", ""):lower() --drop the space and lowercase it
    self.object[kVerb](self.object) --execute the verb action on the object (passing itself)
  else
    --handle arbitrary walk to
    if self.verb == "Walk to" then
      self.player.target = { x = love.mouse.getX(), y = love.mouse.getY() }
    end
    
    --any other verb should cancel without an object
  end
  
  --reset
  self.verb = "Default"
  self:mousemoved(love.mouse.getX(), love.mouse.getY()) --use this to reset object hover?
  return true
end

return stGame