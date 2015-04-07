local Class = require "lib.hump.class"

local object = Class {
  init = function (self, name)
    self.name = name
    self.defaultVerb = "Look at"
  end
}

return object