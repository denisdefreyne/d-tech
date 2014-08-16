local Engine = require('engine')
local Debugger_Components = require('debugger.components')

local StepButton = {}

function StepButton.new()
  local margin = Engine.Types.Point.new(10, 10)
  local lw = love.window

  local self = Engine.Entity.new()

  self:add(Engine.Components.Description,    'Step button')
  self:add(Engine.Components.AnchorPoint,    0, 0)
  self:add(Engine.Components.Scale,          1)
  self:add(Engine.Components.Z,              0)
  self:add(Engine.Components.Size,           100, 40)
  self:add(Engine.Components.Position,       10, 10)
  self:add(Engine.Components.Renderer,       'Button')
  self:add(Debugger_Components.Label,          'Step')
  self:add(Debugger_Components.CursorTracking  )
  self:add(Debugger_Components.StepBehavior    )

  return self
end

return StepButton
