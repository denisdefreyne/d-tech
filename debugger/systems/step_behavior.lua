local StepBehavior = {}
StepBehavior.__index = StepBehavior

local Engine    = require('engine')
local Signal    = require('engine.vendor.hump.signal')
local Gamestate = require('engine.vendor.hump.gamestate')

function StepBehavior.new(entities)
  local t = {
    entities = entities,
    callbacks = {}
  }

  local clickCallback = function()
    local stack = Gamestate.stack()
    stack[#stack-1]:update(0.05)
  end
  t.callbacks.clickCallback = clickCallback
  Signal.register('debugger:systems:cursor-tracking:clicked', clickCallback)

  return setmetatable(t, StepBehavior)
end

function StepBehavior:leave()
  Signal.remove('debugger:systems:cursor-tracking:clicked', self.callbacks.clickCallback)
end

function StepBehavior:update(dt)
end

return StepBehavior
