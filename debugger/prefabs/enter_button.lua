local Engine = require('engine')
local Debugger_Components = require('debugger.components')

local EnterButton = {}

function EnterButton.new()
  local margin = Engine.Types.Point.new(10, 10)
  local lw = love.window

  local self = Engine.Entity.new()

  self:add(Engine.Components.Description,      'Enter button')
  self:add(Engine.Components.AnchorPoint,      0, 0)
  self:add(Engine.Components.Scale,            1)
  self:add(Engine.Components.Z,                0)
  self:add(Engine.Components.Size,             100, 40)
  self:add(Engine.Components.Position,         120, 10)
  self:add(Engine.Components.Renderer,         'Button')
  self:add(Debugger_Components.Label,          'Enter')
  self:add(Debugger_Components.CursorTracking  )
  self:add(Debugger_Components.EnterBehavior   )
  self:add(Debugger_Components.SelectionTracker)

  return self
end

return EnterButton
