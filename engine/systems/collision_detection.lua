local Engine_Helper     = require('engine.helper')
local Engine_Components = require('engine.components')
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
  t.callbacks.addEntity    = function(entity) mapEntity(collision, entity) end
  t.callbacks.removeEntity = function(entity) unmapEntity(collision, entity) end
  entities:addAddCallback(t.callbacks.addEntity)
  entities:addRemoveCallback(t.callbacks.removeEntity)

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
  Signal.remove(Engine_Components.Position.signal, self.callbacks.entityUpdatePosition)
  self.entities:removeAddCallback(self.callbacks.addEntity)
  self.entities:removeRemoveCallback(self.callbacks.removeEntity)
end

function CollisionDetection:update(dt)
  for entity in self.entities:pairs() do
    self:updateEntity(entity, dt)
  end
end

function CollisionDetection:draw()
  ---[[
  love.graphics.setColor(255, 255, 255, 255)
  self.spatialHash:draw('line', true, false)

  love.graphics.setColor(255, 255, 255, 50)
  self.spatialHash:draw('fill', false)
  --]]
end

function CollisionDetection:_pairInteracts(a, b)
  local aCollisionGroup = a:get(Engine_Components.CollisionGroup)
  local bCollisionGroup = b:get(Engine_Components.CollisionGroup)

  if not aCollisionGroup then return false end
  if not bCollisionGroup then return false end

  return aCollisionGroup.name ~= bCollisionGroup.name
end

function CollisionDetection:updateEntity(entity, dt)
  local rect = Engine_Helper.rectForEntity(entity)
  if not rect then return end

  for otherEntity in pairs(self.spatialHash:inRange(rect:coords())) do
    if entity ~= otherEntity then
      local otherRect = Engine_Helper.rectForEntity(otherEntity)

      if otherRect and rect:collidesWith(otherRect) then
        if self:_pairInteracts(entity, otherEntity) then
          Signal.emit('game:systems:collision:detected', entity, otherEntity)
          Signal.emit(CollisionDetection.signal, { a = entity, b = otherEntity })
        end
      end
    end
  end
end

return CollisionDetection
