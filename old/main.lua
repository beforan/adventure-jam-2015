--third party libs
local Gamestate = require "lib.hump.gamestate"

--first party classes

--gamestates
local stGame = require "states.game"


function love.load()
  Gamestate.registerEvents()
  Gamestate.switch(stGame)
end


--some global helpers, because actually useful
--(could encapsulate these in a file later, i guess?

--hover (bounding box mouse collision) for any object with x, y, width, height
function isHover(obj)
  local mouse = { x = love.mouse.getX(), y = love.mouse.getY() }
  
  return mouse.x >= obj.x and mouse.x < obj.x + obj.width
    and mouse.y >= obj.y and mouse.y < obj.y + obj.height
end

--Lua for some reason has no rounding function
math.round = function (a) return math.floor(a+0.5) end