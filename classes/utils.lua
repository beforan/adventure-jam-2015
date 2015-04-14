--"Global" Utility Helper functions
--stored in a singleton

local Class = require "lib.hump.class"
local utils = Class {}

-- hover (bounding box mouse collision) for any object with x, y, width, height
-- can use arbitrary x/y for hit test, or mouse x/y
function utils.isHover(obj, x, y)
  x = x or love.mouse.getX()
  y = y or love.mouse.getY()
  
  return x >= obj.x and x < obj.x + obj.width
    and y >= obj.y and y < obj.y + obj.height
end

return utils()