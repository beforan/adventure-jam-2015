local Class = require "lib.hump.class"
local Signals = require "lib.hump.signal"

local items = {}

local inventory = Class {
  init = function (self)
    self.signals = Signal.new()
  end
}

-- add an item to the inventory by reference
function inventory:add(obj)
  table.insert(items, obj)
  self.signals.emit("item-added")
  self.signals.emit("inventory-changed")
end

-- remove an item from the inventory, by index, name, or reference
function inventory:remove(obj)
  if type(obj) == "number" then
    table.remove(items, obj)
  else
    for i, v in ipairs(items) do
      if v == obj or v.name == obj then
        table.remove(items, i)
        break
      end
    end
  end
  self.signals.emit("item-removed")
  self.signals.emit("inventory-changed")
end

-- see if the inventory contains an item, by index, name, or reference
function inventory:contains(obj)
  if type(obj) == "number" then return items[obj] ~= nil end
  
  for i, v in ipairs(items) do
    if v == obj or v.name == obj then return true end
  end
  return false
end

--get a reference to an object in the inventory, by index or name
function inventory:get(obj)
  if type(obj) == "number" then return items[obj end
  
  for _, v in ipairs(items) do
    if v == obj or v.name == obj then return v end
  end
end