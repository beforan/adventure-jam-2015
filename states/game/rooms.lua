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

function rooms.resetRoom(room)
  room = room or currentRoom.name
  
  if not room then return end
  
  loadedRooms[room] = nil
  rooms.switch(room)
end

return rooms()