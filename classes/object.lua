local Class = require "lib.hump.class"
local Gamestate = require "lib.hump.gamestate"

local object = Class {
  init = function (self, name)
    self.name = name
    self.defaultVerb = "Look at"
  end
}

function object:noop()
  Gamestate.current().player:speak("That doesn't seem to work.")
end

function object:lookat()
  Gamestate.current().player:speak("An object.")
end

function object:give()
  Gamestate.current().player:speak("Well now, this isn't going to work if we can't specify who to give it TO, is it? Better program something, but in the meantime this can test a long message.")
end

function object:talkto()
  Gamestate.current().player:speak("Yes.")
end

function object:open()
  self:noop()
end

function object:close()
  self:noop()
end

function object:push()
  self:noop()
end

function object:pull()
  self:noop()
end

function object:use()
  self:noop()
end

function object:pickup()
  self:noop()
end


return object