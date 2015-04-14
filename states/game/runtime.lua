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
function rt:executeVerb(exec)
  local game = Gamestate.current()
  --check for invalid Location style targets
  if exec.verb ~= game:getVerb("Walk to") then
    -- locations aren't allowed on non-Walk to verbs!
    if not exec.target.type then return end
    
    -- check for second target where expected
    if exec.verb == game:getVerb("Give") then
      if not exec.target2 then return end
    end
    if exec.verb == game:getVerb("Use") and exec.target.useWith then
      if not exec.target2 then return end
    end
  end
  
  self[exec.verb.id](self, exec)
end

function rt:verbWalkto(exec)
  if exec.target.type then
    exec.script = coroutine.create(exec.target.verbWalkto)
  else
    self:walkactor(self:player(), exec.target)
  end
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