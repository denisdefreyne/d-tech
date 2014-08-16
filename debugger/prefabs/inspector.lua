local Engine = require('engine')
local Debugger_Components = require('debugger.components')

local Inspector = {}

function Inspector.new()
  local margin = Engine.Types.Point.new(10, 10)
  local lw = love.window

  local self = Engine.Entity.new()

  self:add(Engine.Components.Description,      'Inspector')
  self:add(Engine.Components.AnchorPoint,      1, 0)
  self:add(Engine.Components.Scale,            1)
  self:add(Engine.Components.Z,                0)
  self:add(Engine.Components.Size,             300, lw.getHeight() - 2 * margin.y)
  self:add(Engine.Components.Position,         lw.getWidth() - margin.x, margin.y)
  self:add(Engine.Components.Renderer,         'Inspector')
  self:add(Debugger_Components.SelectionTracker  )
  self:add(Debugger_Components.Movable           )

  return self
end

return Inspector
