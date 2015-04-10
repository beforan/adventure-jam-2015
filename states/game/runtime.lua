-- Consider this like a runtime interpreter module.
-- In reality it's a singleton class used only in the Game state
-- which provides functions that can be used in any scripts
-- it "interprets" the calling of those functions with parameters
-- it also could provide a large number of shortcuts to common things
-- like the current player controlled actor, the Game state,
-- etc...

local Class = require "lib.hump.class"
local Gamestate = require "lib.hump.gamestate"

local rt = {}

-- verbs
function rt:verbWalkto(target)
  if target.verbWalkto then target:verbWalkto()
  else self:walkactor(self:player(), target) end
end


-- scripting commands
--walk a specific actor to a target location
function rt:walkactor(actor, target)
  actor:moveTo(target.usepos or { x = target.x, y = target.y })
end

--get a specific actor to say something
function rt:sayline(actor, text)
  actor:say(text)
end

-- shortcuts
function rt:player()
  return Gamestate.current().player
end

return rt