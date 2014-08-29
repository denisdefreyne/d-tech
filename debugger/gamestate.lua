local HUMP_Gamestate = require('engine.vendor.hump.gamestate')

local Engine = require('engine')

local Debugger_Spaces  = require('debugger.spaces')
local Debugger_Prefabs = require('debugger.prefabs')

local Debugger = setmetatable({}, { __index = Engine.Gamestate })

function Debugger.new(managedEntities)
  local entities = Engine.Types.EntitiesCollection.new()
  entities:add(Debugger_Prefabs.Inspector.new())
  entities:add(Debugger_Prefabs.StepButton.new())
  entities:add(Debugger_Prefabs.EnterButton.new())

  local spaces = {
    Debugger_Spaces.GUI.new(entities, managedEntities),
    Debugger_Spaces.Arena.new(entities, managedEntities),
  }

  return setmetatable({ spaces = spaces }, { __index = Debugger })
end

return Debugger
