local Class = require "lib.hump.class"
local Room = require "classes.room"
local Signals = require "lib.hump.signal"

--closured vars
local currentRoom = nil
local loadedRooms = {}

local rooms = Class {
  init = function (self)
    self.signals = Signals.new()
  end
}

function rooms.current()
  return currentRoom
end

function rooms:switch(name)
  if not loadedRooms[name] then loadedRooms[name] = Room(name) end
  
  currentRoom = loadedRooms[name]
  self.signals.emit("room-switched")
end

function rooms.resetRoom(room)
  room = room or currentRoom.name
  
  if not room then return end
  
  loadedRooms[room] = nil
  rooms.switch(room)
end

return rooms()