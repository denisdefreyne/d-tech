local Input = {}
Input.__index = Input

local Engine_Types      = require('engine.types')
local Engine_Helper     = require('engine.helper')
local Engine_Components = require('engine.components')
local Engine_System     = require('engine.system')

local Input = Engine_System.newType()

function Input.new(entities)
  local requiredComponentTypes = {}

  local system = Engine_System.new(
    Input, entities, requiredComponentTypes)

  system.hoveredEntity = nil
  system.clickedEntity = nil

  return system
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

-- FIXME: De-duplicate this from renderer system, and allow reverse
local function ipairsSortedByZ(t)
  local keys = {}
  for k in t:pairs() do
    if k:get(Engine_Components.Z) then
      keys[#keys+1] = k
    end
  end

  local compareByZ = function(entityA, entityB)
    local az = entityA:get(Engine_Components.Z)
    local bz = entityB:get(Engine_Components.Z)
    return az.value > bz.value
  end

  table.sort(keys, compareByZ)

  local i = 0
  return function()
    i = i + 1
    if keys[i] then
      return keys[i], t[keys[i]]
    end
  end
end

-- FIXME: This is duplicated!
local function cameraToWorld(system, x, y)
  local camera = system.entities:firstWithComponent(Engine_Components.Camera)

  if not camera then return x, y end

  local cameraPosition = camera:get(Engine_Components.Position)
  local cameraScale    = camera:get(Engine_Components.Scale)
  local cameraRotation = camera:get(Engine_Components.Rotation)
  local cameraSize     = camera:get(Engine_Components.Size)

  if not cameraPosition or not cameraSize then
    error("Cameras require position and size")
  end

  local scaleX = cameraScale and cameraScale.x or 1
  local scaleY = cameraScale and cameraScale.y or 1

  -- Scale
  x, y = x / scaleX, y / scaleY

  -- Rotate
  -- TODO: Implement me

  -- Translate
  local dx = - cameraPosition.x + cameraSize.width  / 2 / scaleX
  local dy = - cameraPosition.y + cameraSize.height / 2 / scaleY
  x, y = x - dx, y - dy

  return x, y
end

local function _newEntityUnderCursor(self)
  local mousePos = getMousePos()
  local x, y = cameraToWorld(self, mousePos.x, mousePos.y)
  mousePos.x, mousePos.y = x, y

  for entity in ipairsSortedByZ(self.entities) do
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

function Input:update(dt)
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

    local whileMouseDownComponent = self.clickedEntity:get(Engine_Components.WhileMouseDown)
    if whileMouseDownComponent then
      whileMouseDownComponent.fn(self.clickedEntity, dt, self.entities)
    end
  end

  for entity in self.entities:pairs() do
    local whileAliveComponent = entity:get(Engine_Components.WhileAlive)
    if whileAliveComponent then
      whileAliveComponent.fn(entity, dt, self.entities)
    end

    local whileKeyDownComponent = entity:get(Engine_Components.WhileKeyDown)
    if whileKeyDownComponent then
      local keysDown = {}
      for i, key in ipairs(whileKeyDownComponent.keys) do
        if love.keyboard.isDown(key) then
          keysDown[key] = true
        end
      end

      for key, _ in pairs(keysDown) do
        whileKeyDownComponent.fn(key, entity, dt, self.entities)
      end
    end
  end
end

function Input:mousepressed(x, y, button)
  x, y = cameraToWorld(self, x, y)

  if button == 'wd' or button == 'wu' then
    for entity in self.entities:pairs() do
      local onMouseWheelMovedC = entity:get(Engine_Components.OnMouseWheelMoved)
      if onMouseWheelMovedC then
        onMouseWheelMovedC.fn(entity, button)
      end
    end

    return
  end

  local newHoveredEntity, newCursorTracking = _newEntityUnderCursor(self)

  if newHoveredEntity then
    self.clickedEntity = newHoveredEntity
    newCursorTracking.isDown = true
    return true
  else
    return false
  end
end

function Input:mousereleased(x, y, button)
  x, y = cameraToWorld(self, x, y)

  if self.clickedEntity then
    local cursorTracking = self.clickedEntity:get(Engine_Components.CursorTracking)
    if cursorTracking.isDown then
      local onClickComponent = self.clickedEntity:get(Engine_Components.OnClick)
      if onClickComponent then
        onClickComponent.fn(self.clickedEntity, self.entities, x, y, button)
      end
    end
    cursorTracking.isDown = false
    self.clickedEntity = nil
    return true
  else
    return false
  end
end

function Input:keypressed(key, isRepeat)
  for entity in self.entities:pairs() do
    local onKeyDownComponent = entity:get(Engine_Components.OnKeyDown)
    if onKeyDownComponent then
      for i, thisKey in ipairs(onKeyDownComponent.keys) do
        if thisKey == key then
          onKeyDownComponent.fn(key, entity, dt, self.entities)
        end
      end
    end
  end
end

return Input
