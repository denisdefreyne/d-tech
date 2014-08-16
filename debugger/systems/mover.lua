local Mover = {}
Mover.__index = Mover

local Engine = require('engine')
local Debugger_Components = require('debugger.components')

local lm = love.mouse

function Mover.new(entities, indiscriminate)
  local t = {
    entities        = entities,
    indiscriminate  = indiscriminate,
    activeEntity    = nil,
    point           = nil,
  }

  return setmetatable(t, Mover)
end

function Mover:update(dt)
  local oldPoint = self.point or Engine.Types.Point.new(lm.getX(), lm.getY())
  local newPoint = Engine.Types.Point.new(lm.getX(), lm.getY())

  if self.activeEntity then
    local position = self.activeEntity:get(Engine.Components.Position)
    if position then
      local vector = oldPoint:vectorTo(newPoint)
      position:addVector(vector)
    end
  end

  self.point = newPoint
end

function Mover:mousepressed(x, y, button)
  for entity in self.entities:pairs() do
    if self.indiscriminate or entity:get(Debugger_Components.Movable) then
      local rect = Engine.rectForEntity(entity)
      if rect and rect:containsPoint(Engine.Types.Point.new(x, y)) then
        self.activeEntity = entity
        return true
      end
    end
  end
  return false
end

function Mover:mousereleased(x, y, button)
  if self.activeEntity then
    self.activeEntity = nil
    return true
  end

  return false
end

return Mover
