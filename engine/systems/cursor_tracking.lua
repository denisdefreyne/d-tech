local CursorTracking = {}
CursorTracking.__index = CursorTracking

local Engine_Types      = require('engine.types')
local Engine_Helper     = require('engine.helper')
local Engine_Components = require('engine.components')
local Signal = require('engine.vendor.hump.signal')

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
  return Engine_Types.Point:new(x, y)
end

local function _oldEntityUnderCursor(self)
  if self.hoveredEntity then
    local cursorTracking = self.hoveredEntity:get(Engine_Components.CursorTracking)
    return self.hoveredEntity, cursorTracking
  else
    return nil, nil
  end
end

local function _newEntityUnderCursor(self)
  local mousePos = getMousePos()

  for entity in self.entities:pairs() do
    local cursorTracking = entity:get(Engine_Components.CursorTracking)
    if cursorTracking then
      local rect = Engine_Helper.rectForEntity(entity)
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
    if oldCursorTracking then oldCursorTracking.isHovering = false end
    if newCursorTracking then newCursorTracking.isHovering = true  end
    self.hoveredEntity = newHoveredEntity
  end

  if self.clickedEntity and self.clickedEntity ~= newHoveredEntity then
    local clickedCursorTracking = self.clickedEntity:get(Engine_Components.CursorTracking)
    clickedCursorTracking.isDown = false
  elseif self.clickedEntity and self.clickedEntity == newHoveredEntity then
    local clickedCursorTracking = self.clickedEntity:get(Engine_Components.CursorTracking)
    clickedCursorTracking.isDown = true
  end
end

function CursorTracking:mousepressed(x, y, button)
  local newHoveredEntity, newCursorTracking = _newEntityUnderCursor(self)

  if newHoveredEntity then
    self.clickedEntity = newHoveredEntity
    newCursorTracking.isDown = true
    return true
  else
    return false
  end
end

function CursorTracking:mousereleased(x, y, button)
  if self.clickedEntity then
    local cursorTracking = self.clickedEntity:get(Engine_Components.CursorTracking)
    if cursorTracking.isDown then
      local onClickComponent = self.clickedEntity:get(Engine_Components.OnClick)
      if onClickComponent then
        onClickComponent.fn(self.clickedEntity)
      end
    end
    cursorTracking.isDown = false
    self.clickedEntity = nil
    return true
  else
    return false
  end
end

return CursorTracking
