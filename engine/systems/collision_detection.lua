local Engine_Helper     = require('engine.helper')
local Engine_Components = require('engine.components')
local Engine_Types      = require('engine.types')
local Signal            = require('engine.vendor.hump.signal')

local CollisionDetection = {}
CollisionDetection.__index = CollisionDetection

local SpatialHash = require('engine.vendor.collider.spatialhash')

CollisionDetection.signal = 'engine:systems:collision:detected'

local function mapEntity(collision, entity)
  local rect = Engine_Helper.rectForEntity(entity)
  if not rect then return end

  collision.spatialHash:insert(
    entity, rect:left(), rect:top(), rect:right(), rect:bottom())
end

local function unmapEntity(collision, entity)
  local rect = Engine_Helper.rectForEntity(entity)
  if not rect then return end

  collision.spatialHash:remove(
    entity,
    rect:left(), rect:top(), rect:right(), rect:bottom())
end

function CollisionDetection.new(entities)
  local t = {
    entities    = entities,
    spatialHash = SpatialHash(60),
    callbacks   = {},
  }

  local collision = setmetatable(t, CollisionDetection)

  -- Set entity add/remove callbacks
  t.callbacks.addEntity =
    function(entity, entities) mapEntity(collision, entity) end
  t.callbacks.removeEntity =
    function(entity, entities) unmapEntity(collision, entity) end
  Signal.register(
    Engine_Types.EntitiesCollection.ADD_SIGNAL,
    t.callbacks.addEntity)
  Signal.register(
    Engine_Types.EntitiesCollection.REMOVE_SIGNAL,
    t.callbacks.removeEntity)

  -- Set position update callback
  local entityUpdatePosition = function(attributes)
    local component = attributes.component
    local entity = entities:withExactComponent(component)

    local oldRect = Engine_Helper.rectForEntity(entity)
    local newRect = Engine_Helper.rectForEntity(entity)

    oldRect.origin.x = oldRect.origin.x - attributes.dx
    oldRect.origin.y = oldRect.origin.y - attributes.dy

    collision.spatialHash:update(
      entity,
      oldRect:left(), oldRect:top(), oldRect:right(), oldRect:bottom(),
      newRect:left(), newRect:top(), newRect:right(), newRect:bottom())
  end
  t.callbacks.entityUpdatePosition = entityUpdatePosition
  Signal.register(Engine_Components.Position.signal, entityUpdatePosition)

  -- Add to hash
  for entity in collision.entities:pairs() do
    mapEntity(collision, entity)
  end

  return collision
end

function CollisionDetection:leave()
  Signal.remove(
    Engine_Components.Position.signal,
    self.callbacks.entityUpdatePosition)
  Signal.remove(
    Engine_Types.EntitiesCollection.ADD_SIGNAL,
    self.callbacks.addEntity)
  Signal.remove(
    Engine_Types.EntitiesCollection.REMOVE_SIGNAL,
    self.callbacks.removeEntity)
end

function CollisionDetection:update(dt)
  for entity in self.entities:pairs() do
    self:updateEntity(entity, dt)
  end
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
        Signal.emit('game:systems:collision:detected', entity, otherEntity)
        Signal.emit(CollisionDetection.signal, { a = entity, b = otherEntity })
      end
    end
  end
end

return CollisionDetection
