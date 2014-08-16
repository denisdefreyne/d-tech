local Input = {}
Input.__index = Input

local HUMP_Gamestate = require('engine.vendor.hump.gamestate')

function Input.new(entities)
  local t = {
    entities = entities,
  }

  return setmetatable(t, Input)
end

function Input:keypressed(key, isrepeat)
  if key == 'tab' then
    HUMP_Gamestate.pop()
    return true
  end

  return false
end

return Input
