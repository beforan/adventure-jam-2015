--"Global" Utility Helper functions
--stored in a singleton

local Class = require "lib.hump.class"
local utils = Class {}

--hover (bounding box mouse collision) for any object with x, y, width, height
function utils:isHover(obj)
  local mouse = { x = love.mouse.getX(), y = love.mouse.getY() }
  
  return mouse.x >= obj.x and mouse.x < obj.x + obj.width
    and mouse.y >= obj.y and mouse.y < obj.y + obj.height
end

return utils()