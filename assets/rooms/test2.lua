local RT = require "states.game.runtime"
local Rooms = require "states.game.rooms"
local Object = require "classes.object"

return {
  name = "test2",
  background = "",
  foreground = "",
  width = 300,
  clipY = 0,
  objects = {
    {
      name = "dog",
      x = 250,
      y = 350,
      useposition = { x = 300, y = 350 },
      verbBad = function (self)
        RT:player():say("You can't do that to a dog!")
      end,
      verbLookat = function (self)
        RT:player():say("It's a dog. Can't you tell from the shape, and detail?")
      end,
      verbPickup = function (self)
        RT:walkactor(RT:player(), self)
        while RT:player():isMoving() do
          coroutine.yield()
        end
        
        --block while we actually add, to prevent cancelling in the middle?
        --self.blocking = true
        RT:player():say("I hope he can breathe alright in there...")
        RT:player():pickup(self)
        Rooms.current():remove(self)
        
        --now we're done, tidy up some bits
        self.verbPickup = Object.verbPickup
        --self.blocking = false
      end
    }
  },
  actors = {},
  scripts = {}
}