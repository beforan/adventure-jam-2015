local Gamestate = require "lib.hump.gamestate"
local Rooms = require "states.game.rooms"

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
      noop = function (self) Gamestate.current().player:speak("You can't do that to a hat!") end,
      lookat = function (self) Gamestate.current().player:speak("It's a hat. Can't you tell from the shape, and detail?") end,
      pickup = function (self)
        Gamestate.current().player:speak("This should come in handy")
        Gamestate.current().inventory:add(self)
        for i, v in ipairs(Rooms.current().objects) do
          if v == self then table.remove(Rooms.current().objects, i) end
        end
        self.pickup = self.noop
      end
    }
  }
}