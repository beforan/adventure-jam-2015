local Gamestate = require "lib.hump.gamestate"

function love.load()
  Gamestate.registerEvents()
  Gamestate.switch(require "states.game")
end

--Lua for some reason has no rounding function
math.round = function (a) return math.floor(a+0.5) end