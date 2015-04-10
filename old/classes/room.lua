local Class = require "lib.hump.class"
local Object = require "classes.object"

local room = Class {
  init = function (self, name)
    --load properties from a simple table :)
    local spec = require("assets.rooms." .. name)
    
    self.name = name
    self.objects = {}
    for _, v in ipairs(spec.objects) do
      table.insert(self.objects, Object(v))
    end
  end
}

function room:draw()
  --draw the room background
  love.graphics.setColor(180, 0, 0, 255)
  love.graphics.rectangle("fill", 0, 0, 1280, 500)
  
  --draw the room's objects
  for _, v in ipairs(self.objects) do
    v:draw()
  end
end

function room:remove(obj)
  for i, v in ipairs(self.objects) do
    if v == obj then
      table.remove(self.objects, i)
      break
    end
  end
end

return room