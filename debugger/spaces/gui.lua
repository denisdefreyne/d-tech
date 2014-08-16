local Engine = require('engine')

local Debugger_Systems_Mover          = require('debugger.systems.mover')
local Debugger_Systems_Input          = require('debugger.systems.input')
local Debugger_Systems_CursorTracking = require('debugger.systems.cursor_tracking')
local Debugger_Systems_StepBehavior   = require('debugger.systems.step_behavior')

local GUI = {}

function GUI.new(entities, managedEntities)
  local systems = {
    Engine.Systems.Rendering.new(entities),
    Debugger_Systems_Mover.new(entities),
    Debugger_Systems_Input.new(entities),
    Debugger_Systems_CursorTracking.new(entities),
    Debugger_Systems_StepBehavior.new(entities),
  }

  return Engine.Space.new(entities, systems)
end

return GUI
