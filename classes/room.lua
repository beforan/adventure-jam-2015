local Class = require "lib.hump.class"
local Object = require "classes.object"
local Actor = require "classes.actor"

local room = Class {
  init = function (self, name)
    --load properties from a simple table :)
    local spec = require("assets.rooms." .. name)
    
    self.width = spec.width or love.window.getWidth()
    --self.height = spec.height
    
    self.name = name
    self.objects = {}
    if spec.objects then
      for _, v in ipairs(spec.objects) do
        table.insert(self.objects, Object(v))
      end
    end
    self.actors = {}
    if spec.actors then
      for _, v in ipairs(spec.actors) do
        table.insert(self.actors, Actor(v))
      end
    end
  end
}

function room:update(dt)
  for _, v in ipairs(self.actors) do
    v:update(dt)
  end
end

function room:draw()
  --draw the room background
  love.graphics.setColor(180, 0, 0, 255)
  love.graphics.rectangle("fill", 0, 0, self.width, 500)
  
  --draw the room's objects
  for _, v in ipairs(self.objects) do
    v:draw()
  end
  
  --draw the room's actors
  for _, v in ipairs(self.actors) do
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