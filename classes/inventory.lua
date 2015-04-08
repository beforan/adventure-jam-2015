local Gamestate = require "lib.hump.gamestate"
local Class = require "lib.hump.class"
local Button = require "classes.button"

local inventory = Class {
  init = function (self)
    self.buttonStart = 1
    self.items = {}
    self.buttons = {}
    self.upbutton = Button(
      "U", 565, 530, 40, 85,
      function ()
        if self.buttonStart == 1 then return end
        self.buttonStart = self.buttonStart - 7
        self:updateButtons()
      end)
    self.downbutton = Button(
      "D", 565, 625, 40, 85,
      function ()
        if self.buttonStart + 21 > #self.items then return end
        self.buttonStart = self.buttonStart + 7
        self:updateButtons()
      end)
  end
}

function inventory:updateButtons()
  self.buttons = {}
  local origin = { x = 610, y = 520 }
  local pad, w, h = 5, 90, 60
  local row = 1
  
  for i = 1, 21 do
    local j = self.buttonStart + i - 1
    local col = i - ((row-1) * 7)
    local x = origin.x + ((col-1) * w) + (col * pad)
    local y = origin.y + ((row-1) * h) + (row * pad)
    
    if self.items[j] then
      self.buttons[i] = Button(
        self.items[j].name,
        x, y, w, h,
        function () Gamestate.current().object = self.items[j] end)
    else
      self.buttons[i] = Button(
      nil,
      x, y, w, h,
      nil)
    end
    
    if i % 7 == 0 then row = row + 1 end
  end
end

function inventory:draw()
  for _, v in ipairs(self.buttons) do
    v:draw()
  end
  
  self.upbutton:draw()
  self.downbutton:draw()
end

return inventory