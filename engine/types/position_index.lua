-- TODO vendor in engine
local bump = require('vendor.bump.bump')
local Signal = require('engine.vendor.hump.signal')
local Engine_Helper = require('engine.helper')

local PositionIndex = {}
PositionIndex.__index = PositionIndex

function PositionIndex.new(entities)
  -- FIXME: filter by entities collection

  local new = setmetatable({ entities = entities }, PositionIndex)

  local E_T_EC = require('engine.types.entities_collection')
  local E_E    = require('engine.entity')
  local E_C    = require('engine.components')

  local signalNames = {
    E_T_EC.ENTITY_ADDED_SIGNAL,
    E_T_EC.ENTITY_REMOVED_SIGNAL,
    E_E.COMPONENT_ADDED_SIGNAL,
    E_E.COMPONENT_REMOVED_SIGNAL,
    E_C.Position.UPDATED_SIGNAL,
  }

  local signalHandles = {}

  local wrap = function(name, fn, self)
    return function(attributes)
      fn(self, name, attributes)
    end
  end

  for _, name in pairs(signalNames) do
    local handle = Signal.register(name, wrap(name, PositionIndex.handleSignal, new))
    table.insert(signalHandles, { name = name, handle = handle })
  end

  return new
end

function PositionIndex:leave()
  for _, handle in pairs(self.signalHandles) do
    Signal.remove(handle.name, handle.handle)
  end
end

function PositionIndex:queryRect(rect, filter)
  return self.world:queryRect(rect:left(), rect:top(), rect.size.width, rect.size.height, filter)
end

function PositionIndex:queryPoint(point, filter)
  return self.world:queryPoint(point.x, point.y, filter)
end

local function updateEntityWithRect(self, entity, rect)
  local fn = self.world:hasItem(entity) and self.world.move or self.world.add

  fn(
    self.world,
    entity,
    rect:left(), rect:top(),
    rect.size.width, rect.size.height
  )
end

local function updateEntity(self, entity)
  if not self.entities:contains(entity) then return end

  local rect = Engine_Helper.rectForEntity(entity)
  if rect then
    updateEntityWithRect(self, entity, rect)
  end
end

local function removeEntity(self, entity)
  if self.world:hasItem(entity) then
    self.world:remove(entity)
  end
end

local function updatePositionComponent(self, positionComponent)
  local entity = self.entities:withExactComponent(positionComponent)
  if entity then
    updateEntity(self, entity)
  end
end

function PositionIndex:handleSignal(name, attributes)
  if not self.world then
    self.world = bump.newWorld(15)
  end

  local E_T_EC = require('engine.types.entities_collection')
  local E_E    = require('engine.entity')
  local E_C    = require('engine.components')

  if name == E_T_EC.ENTITY_ADDED_SIGNAL then
    updateEntity(self, attributes.entity)
  elseif name == E_T_EC.ENTITY_REMOVED_SIGNAL then
    removeEntity(self, attributes.entity)
  elseif name == E_E.COMPONENT_ADDED_SIGNAL then
    updateEntity(self, attributes.entity)
  elseif name == E_E.COMPONENT_REMOVED_SIGNAL then
    removeEntity(self, attributes.entity)
  elseif name == E_C.Position.UPDATED_SIGNAL then
    updatePositionComponent(self, attributes.component)
  else
    error('Does not exist')
  end
end

return PositionIndex
