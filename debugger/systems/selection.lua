local Selection = {}
Selection.__index = Selection

local Debugger_Components = require('debugger.components')

local Engine = require('engine')

local function growRect(rect, padding)
  return Engine.Types.Rect.new(
    rect.origin.x - padding,
    rect.origin.y - padding,
    rect.size.width + 2 * padding,
    rect.size.height + 2 * padding)
end

function Selection.new(entities, monitoredEntities)
  local t = {
    entities          = entities,
    monitoredEntities = monitoredEntities,
    selectedEntity    = nil,
  }

  return setmetatable(t, Selection)
end

function Selection:updateInterestedEntities()
  for entity in self.entities:pairs() do
    local component = entity:get(Debugger_Components.SelectionTracker)
    if component then
      component.selectedEntity = self.selectedEntity
    end
  end
end

function Selection:draw()
  if self.selectedEntity then
    local rect = Engine.rectForEntity(self.selectedEntity)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.rectangle(
      "line",
      rect.origin.x,
      rect.origin.y,
      rect.size.width,
      rect.size.height)
  end
end

function Selection:mousereleased(x, y, button)
  for entity in self.monitoredEntities:pairs() do
    local rect = Engine.rectForEntity(entity)
    if rect and growRect(rect, 10):containsPoint(Engine.Types.Point.new(x, y)) then
      self.selectedEntity = entity
      self:updateInterestedEntities()
      return true
    end
  end

  self.selectedEntity = nil
  self:updateInterestedEntities()
  return false
end

return Selection
