local RT = require "states.game.runtime"
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
      useWith = true,
      verbBad = function (self)
        RT:player():say("You can't do that to a hat!")
      end,
      verbLookat = function (self)
        RT:player():say("It's a hat. Can't you tell from the shape, and detail?")
      end,
      verbPickup = function (self)
        RT:block()
        RT:walkactor(RT:player(), self)
        while RT:player():isMoving() do
          coroutine.yield()
        end
        
        --block while we actually add, to prevent cancelling in the middle?
        
        RT:player():say("This should come in handy")
        RT:player():pickup(self)
        Rooms.current():remove(self)
        
        --now we're done, tidy up some bits
        self.verbPickup = Object.verbPickup
        RT:unblock()
      end,
      verbGive = function (self, dt, exec)
        if exec.target2.name == "dog" then
          RT:player():say("It won't fit him.")
        else
          self:verbBad()
        end
      end,
      verbUse = function (self, dt, exec)
        self:verbGive(dt, exec)
      end
    },
    {
      name = "test2",
      x = 200,
      y = 100,
      width = 100,
      height = 300,
      usepos = { x = 250, y = 400 },
      verbLookat = function (self)
        RT:player():say("Looks like test2 is on the other side of the doorway.")
      end,
      verbWalkto = function (self)
        RT:walkactor(RT:player(), self)
        while RT:player():isMoving() do
          coroutine.yield()
        end
        Rooms.switch("test2")
      end
    }
  },
  actors = {},
  scripts = {}
}