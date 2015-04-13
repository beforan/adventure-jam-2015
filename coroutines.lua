--[[local function co (arg1, arg2)
  print("arg1: " .. arg1)
  print("arg2: " .. arg2)
  arg1 = coroutine.yield()
  print("arg1: " .. arg1)
  print("arg2: " .. arg2)
end

local c = coroutine.create(co)

coroutine.resume(c, "1", "2")
coroutine.resume(c, "3")--]]

local Verb = require "classes.verb"

local v1 = Verb("Test", "q")
local v2 = Verb("Test", "q")
local v3 = Verb("Test", "l")

print(v1 == v2, v2 == v3, v1 == v3)