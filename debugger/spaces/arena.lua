local Engine = require('engine')

local Debugger_Systems_Selection = require('debugger.systems.selection')
local Debugger_Systems_Mover     = require('debugger.systems.mover')

local Arena = {}

function Arena.new(entities, monitoredEntities)
  local systems = {
    Engine.Systems.Rendering.new(monitoredEntities),
    Debugger_Systems_Selection.new(entities, monitoredEntities),
    Debugger_Systems_Mover.new(monitoredEntities, true),
  }

  return Engine.Space.new(monitoredEntities, systems)
end

return Arena
