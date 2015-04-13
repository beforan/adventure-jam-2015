local Class = require "lib.hump.class"
local Button = require "classes.button"
local Gamestate = require "lib.hump.gamestate"
local Hotspot = require "classes.hotspot"

local ui = Class {
  init = function (self)
    --ui settings
    self.buttons = {
      pad = 5,
      width = 90,
      height = 60,
      cols = 7,
      rows = 3
    }
    
    self.buttonsUpDown = {
      pad = 5,
      width = 40,
      height = 85,
      cols = 1,
      rows = 2
    }
    
    self.zone = Hotspot(610, 520,
      self.buttons.width * self.buttons.cols + self.buttons.pad * (self.buttons.cols + 1),
      self.buttons.height * self.buttons.rows + self.buttons.pad * (self.buttons.rows + 1))
    
    self.zoneUpDown = Hotspot(560, 520,
      self.buttons.width * self.buttons.cols + self.buttons.pad * (self.buttons.cols + 1),
      self.buttons.height * self.buttons.rows + self.buttons.pad * (self.buttons.rows + 1))
    
    self.iBtnFirst = 1 -- item index of the first button
    
    -- Up Down buttons
    self.buttonsUpDown.up = Button(
      "U",
      self.zoneUpDown.x + self.buttonsUpDown.pad,
      self.zoneUpDown.y + self.buttonsUpDown.pad * 2,
      self.buttonsUpDown.width, self.buttonsUpDown.height,
      function ()
        if self.iBtnFirst == 1 then return end
        self.iBtnFirst = self.iBtnFirst - self.buttons.cols
        self:updateButtons()
      end)
    self.buttonsUpDown.down = Button(
      "D",
      self.zoneUpDown.x + self.buttonsUpDown.pad,
      self.zoneUpDown.y + self.buttonsUpDown.height + self.buttonsUpDown.pad * 4,
      self.buttonsUpDown.width, self.buttonsUpDown.height,
      function ()
        local inventory = Gamestate.current().player.inventory
        if self.iBtnFirst + (self.buttons.cols * self.buttons.rows) > inventory:count() then return end
        self.iBtnFirst = self.iBtnFirst + self.buttons.cols
        self:updateButtons()
      end)
  end
}

function ui:update()
  if #self.buttons == 0 then
    self:updateButtons()
  end
end

function ui:updateButtons()
  for i = 1, (self.buttons.cols * self.buttons.rows) do
    self.buttons[i] = nil
  end
  
  local row = 1
  local inventory = Gamestate.current().player.inventory
  
  --update the item buttons
  for i = 1, (self.buttons.cols * self.buttons.rows) do
    local j = self.iBtnFirst + i - 1
    local col = i - ((row-1) * self.buttons.cols)
    local x = self.zone.x + ((col-1) * self.buttons.width) + (col * self.buttons.pad)
    local y = self.zone.y + ((row-1) * self.buttons.height) + (row * self.buttons.pad)
    
    local item = inventory:get(j)
    if item then
      self.buttons[i] = Button(
        item.name,
        x, y, self.buttons.width, self.buttons.height,
        function () Gamestate.current().current.target = item end)
    else
      self.buttons[i] = Button(
      nil,
      x, y, self.buttons.width, self.buttons.height,
      nil)
    end
    
    if i % self.buttons.cols == 0 then row = row + 1 end
  end
  
  --update the up/down buttons
  if self.iBtnFirst == 1 then
    self.buttonsUpDown.up.active = false
    self.buttonsUpDown.up.content = ""
  else
    self.buttonsUpDown.up.active = true
    self.buttonsUpDown.up.content = "U"
  end
  if self.iBtnFirst + (self.buttons.cols * self.buttons.rows) > inventory:count() then
    self.buttonsUpDown.down.active = false
    self.buttonsUpDown.down.content = ""
  else
    self.buttonsUpDown.down.active = true
    self.buttonsUpDown.down.content = "D"
  end
end

function ui:draw()
  for _, v in ipairs(self.buttons) do
    v:draw()
  end
  
  self.buttonsUpDown.up:draw()
  self.buttonsUpDown.down:draw()
end

-- Callbacks
function ui:inventoryChanged()
  self:updateButtons()
end

return ui()