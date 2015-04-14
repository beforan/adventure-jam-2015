local Class = require "lib.hump.class"
local RT = "states.game.runtime"

local verb = Class {
  init = function (self, name, key)
    self.name = name
    self.key = key or name:sub(1,1):lower()
    self.id = "verb"..name:gsub(" ", "")
  end
}

return verb