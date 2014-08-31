local Engine_Helper     = require('engine.helper')
local Engine_Components = require('engine.components')
local Engine_System     = require('engine.system')
local Engine_Types      = require('engine.types')
local Signal            = require('engine.vendor.hump.signal')
local SpatialHash       = require('engine.vendor.collider.spatialhash')

local CollisionDetection = Engine_System.newType()

CollisionDetection.COLLIDING_SIGNAL = 'engine:systems:collision:detected'

function CollisionDetection.new(entities)
  local requiredComponentTypes = {}
  local signalNames = {
    -- FIXME: Make naming more consistent
    Engine_Types.EntitiesCollection.ENTITY_ADDED_SIGNAL,
    Engine_Types.EntitiesCollection.ENTITY_REMOVED_SIGNAL,
    Engine_Components.Position.UPDATED_SIGNAL,
  }

  local system = Engine_System.new(
    CollisionDetection, entities, requiredComponentTypes, signalNames)

  system.spatialHash = SpatialHash(60)

  return system
end

function CollisionDetection:handleSignal(name, attributes)
  if name == Engine_Types.EntitiesCollection.ENTITY_ADDED_SIGNAL then
    self:handleEntityAdded(attributes)
  elseif name == Engine_Types.EntitiesCollection.ENTITY_REMOVED_SIGNAL then
    self:handleEntityRemoved(attributes)
  elseif name == Engine_Components.Position.UPDATED_SIGNAL then
    self:handlePositionUpdated(attributes)
  else
    -- FIXME: Error
  end
end

function CollisionDetection:handleEntityAdded(attributes)
  local rect = Engine_Helper.rectForEntity(attributes.entity)
  if not rect then return end

  self.spatialHash:insert(
    attributes.entity, rect:left(), rect:top(), rect:right(), rect:bottom())
end

function CollisionDetection:handleEntityRemoved(attributes)
  local rect = Engine_Helper.rectForEntity(attributes.entity)
  if not rect then return end

  self.spatialHash:remove(
    attributes.entity,
    rect:left(), rect:top(), rect:right(), rect:bottom())
end

function CollisionDetection:handlePositionUpdated(attributes)
  local component = attributes.component
  local entity = self.entities:withExactComponent(component)
  if not entity then return end

  local oldRect = Engine_Helper.rectForEntity(entity)
  local newRect = Engine_Helper.rectForEntity(entity)

  oldRect.origin:update(
    oldRect.origin.x - attributes.dx,
    oldRect.origin.y - attributes.dy)

  self.spatialHash:update(
    entity,
    oldRect:left(), oldRect:top(), oldRect:right(), oldRect:bottom(),
    newRect:left(), newRect:top(), newRect:right(), newRect:bottom())
end

function CollisionDetection:draw()
  --[[
  love.graphics.setColor(255, 255, 255, 30)
  self.spatialHash:draw('line', true, false)

  love.graphics.setColor(255, 255, 255, 20)
  self.spatialHash:draw('fill', false)
  --]]
end

function CollisionDetection:updateEntity(entity, dt)
  local rect = Engine_Helper.rectForEntity(entity)
  if not rect then return end

  for otherEntity in pairs(self.spatialHash:inRange(rect:coords())) do
    if entity ~= otherEntity then
      local otherRect = Engine_Helper.rectForEntity(otherEntity)

      if otherRect and rect:collidesWith(otherRect) then
        Signal.emit(CollisionDetection.COLLIDING_SIGNAL, { a = entity, b = otherEntity })
      end
    end
  end
end

return CollisionDetection
