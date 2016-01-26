local Camera = require "lib.hump.camera"
local Gamestate = require "lib.hump.gamestate"
local Rooms = require "states.game.rooms"

local cam = Camera(0, 0)

cam.viewport = function () love.graphics.rectangle(
      "fill", 0, 0, love.graphics.getWidth(), 500) end

function cam:roomUpdate() -- on game update
  local player = Gamestate.current().player
  local wnd_w = love.graphics.getWidth()
  local wnd_h = love.graphics.getHeight()
  if player.x > (wnd_w / 2) and player.x < Rooms.current().width - (wnd_w / 2) then
    self:lookAt(player.x, wnd_h / 2)
  end
end

function cam:roomInit() -- on room switch :)
  local player = Gamestate.current().player
  local wnd_w = love.graphics.getWidth()
  local wnd_h = love.graphics.getHeight()
  if player.x > (wnd_w / 2) and player.x < Rooms.current().width - (wnd_w / 2) then
    self:lookAt(player.x, wnd_h / 2)
  else
    if Rooms.current().width > wnd_w then
      self:lookAt(wnd_w / 2, wnd_h / 2)
    else
      self:lookAt(Rooms.current().width / 2, wnd_h / 2)
    end
  end
end

return cam