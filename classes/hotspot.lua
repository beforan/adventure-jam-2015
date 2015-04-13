-- Represents an arbitrary hoverable rect
local Class = require "lib.hump.class"
local Utils = require "classes.utils"

local hotspot = Class {
  init = function (self, x, y, w, h)
    self.x = x
    self.y = y
    self.width = w
    self.height = h
  end
}

function hotspot:isHover(x, y)
  Utils.isHover(self, x, y)
end

return hotspot