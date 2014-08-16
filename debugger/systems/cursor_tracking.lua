local CursorTracking = {}
CursorTracking.__index = CursorTracking

local Engine = require('engine')
local Signal = require('engine.vendor.hump.signal')

local Debugger_Components = require('debugger.components')

function CursorTracking.new(entities)
  local t = {
    entities = entities,
    hoveredEntity = nil,
    clickedEntity = nil,
  }

  return setmetatable(t, CursorTracking)
end

local function getMousePos()
  local x, y = love.mouse.getPosition()
  return Engine.Types.Point.new(x, y)
end

local function _oldEntityUnderCursor(self)
  if self.hoveredEntity then
    local cursorTracking = self.hoveredEntity:get(Debugger_Components.CursorTracking)
    return self.hoveredEntity, cursorTracking
  else
    return nil, nil
  end
end

local function _newEntityUnderCursor(self)
  local mousePos = getMousePos()

  for entity in self.entities:pairs() do
    local cursorTracking = entity:get(Debugger_Components.CursorTracking)
    if cursorTracking then
      local rect = Engine.rectForEntity(entity)
      if rect and rect:containsPoint(mousePos) then
        return entity, cursorTracking
      end
    end
  end

  return nil, nil
end

function CursorTracking:update(dt)
  local oldHoveredEntity, oldCursorTracking = _oldEntityUnderCursor(self)
  local newHoveredEntity, newCursorTracking = _newEntityUnderCursor(self)

  if oldHoveredEntity ~= newHoveredEntity then
    if oldCursorTracking then oldCursorTracking.hovering = false end
    if newCursorTracking then newCursorTracking.hovering = true  end
    self.hoveredEntity = newHoveredEntity
  end

  if self.clickedEntity and self.clickedEntity ~= newHoveredEntity then
    local clickedCursorTracking = self.clickedEntity:get(Debugger_Components.CursorTracking)
    clickedCursorTracking.clicked = false
  elseif self.clickedEntity and self.clickedEntity == newHoveredEntity then
    local clickedCursorTracking = self.clickedEntity:get(Debugger_Components.CursorTracking)
    clickedCursorTracking.clicked = true
  end
end

function CursorTracking:mousepressed(x, y, button)
  local newHoveredEntity, newCursorTracking = _newEntityUnderCursor(self)

  if newHoveredEntity then
    self.clickedEntity = newHoveredEntity
    newCursorTracking.clicked = true
    return true
  else
    return false
  end
end

function CursorTracking:mousereleased(x, y, button)
  if self.clickedEntity then
    local cursorTracking = self.clickedEntity:get(Debugger_Components.CursorTracking)
    if cursorTracking.clicked then
      Signal.emit('debugger:systems:cursor-tracking:clicked', self.clickedEntity)
    end
    cursorTracking.clicked = false
    self.clickedEntity = nil
    return true
  else
    return false
  end
end

return CursorTracking
