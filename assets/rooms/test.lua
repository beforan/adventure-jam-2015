local Gamestate = require "lib.hump.gamestate"
local Rooms = require "states.game.rooms"
local Object = require "classes.object"

return {
  name = "test",
  background = "",
  foreground = "",
  clipY = 0,
  objects = {
    {
      name = "hat",
      x = 500,
      y = 150,
      useposition = { x = 50, y = 350 },
      noop = function (self)
        Gamestate.current().player:speak("You can't do that to a hat!")
        Gamestate.current().executing = nil
      end,
      lookat = function (self)
        Gamestate.current().player:speak("It's a hat. Can't you tell from the shape, and detail?")
        Gamestate.current().executing = nil
      end,
      pickup = function (self)
        local game = Gamestate.current()
        game.player.target = self.useposition
        if game.player.x == self.useposition.x and game.player.y == self.useposition.y then
          --block while we actually add, to prevent cancelling in the middle?
          self.blocking = true
          game.player:speak("This should come in handy")
          game.inventory:add(self)
          Rooms.current():remove(self)
          
          --now we're done, tidy up some bits
          self.pickup = Object.pickup
          game.executing = nil
          self.blocking = false
        end
      end
    }
  }
}