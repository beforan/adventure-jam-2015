--third party libs
local Gamestate = require "lib.hump.gamestate"

--first party classes

--gamestates
local stGame = require "states.game"


function love.load()
  Gamestate.registerEvents()
  Gamestate.switch(stGame)
end