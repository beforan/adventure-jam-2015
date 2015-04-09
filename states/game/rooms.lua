local Class = require "lib.hump.class"
local Room = require "classes.room"

--closured vars
local currentRoom = nil
local loadedRooms = {}

local rooms = Class {
  init = function (self)
    
  end
}

function rooms.current()
  return currentRoom
end

function rooms.switch(name)
  if not loadedRooms[name] then loadedRooms[name] = Room(name) end
  
  currentRoom = loadedRooms[name]
end

return rooms()