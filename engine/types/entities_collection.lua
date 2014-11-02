local class = require('engine.vendor.middleclass.middleclass')
local fun = require('engine.vendor.luafun.fun')
local Signal = require('engine.vendor.hump.signal')

local EntitiesCollection = class('EntitiesCollection')

local _set
local function Set()
  if not _set then _set = require('engine.types.set') end
  return _set
end

local _positionIndex
local function PositionIndex()
  if not _positionIndex then _positionIndex = require('engine.types.position_index') end
  return _positionIndex
end

local _componentIndex
local function ComponentIndex()
  if not _componentIndex then _componentIndex = require('engine.types.component_index') end
  return _componentIndex
end

EntitiesCollection.ENTITY_ADDED_SIGNAL   = 'engine:types:entities_collection:added'
EntitiesCollection.ENTITY_REMOVED_SIGNAL = 'engine:types:entities_collection:removed'

function EntitiesCollection:initialize(name)
  self.name = name
  self.r = Set():new()
  self.dead = Set():new()
  self.positionIndex = PositionIndex().new(self)
  self.componentIndex = ComponentIndex().new(self)
end

function EntitiesCollection:__tostring()
  return '(EntitiesCollection ' .. self.name .. ')'
end

function EntitiesCollection:add(entity)
  self.r:add(entity)
  Signal.emit(
    EntitiesCollection.ENTITY_ADDED_SIGNAL,
    { entity = entity, entitiesCollection = self })
end

function EntitiesCollection:contains(entity)
  return self.r:contains(entity)
end

function EntitiesCollection:queryPoint(point)
  return self.positionIndex:queryPoint(point)
end

function EntitiesCollection:queryRect(rect)
  return self.positionIndex:queryRect(rect)
end

function EntitiesCollection:queryComponentType(componentType)
  return self.componentIndex:queryComponentType(componentType)
end

function EntitiesCollection:firstWithComponent(componentType)
  return self:firstWithComponents({ componentType })
end

function EntitiesCollection:withExactComponent(component)
  local findFn = function(e)
    for k, v in pairs(e) do
      if v == component then
        return true
      end
    end
    return false
  end

  return self:find(findFn)
end

function EntitiesCollection:firstWithComponents(componentTypes)
  local findFn = function(e)
    for _, componentType in pairs(componentTypes) do
      if not e:get(componentType) then
        return false
      end
    end
    return true
  end

  return self:find(findFn)
end

function EntitiesCollection:remove(entity)
  Signal.emit(
    EntitiesCollection.ENTITY_REMOVED_SIGNAL,
    { entity = entity, entitiesCollection = self })

  entity:markAsDead()
  self.dead:add(entity)
end

function EntitiesCollection:prune()
  for e in self.dead:pairs() do
    self.r:remove(e)
  end

  self.dead:empty()
end

function EntitiesCollection:find(fn)
  return fun.nth(1, fun.filter(fn, self:pairs()))
end

local function isAlive(e)
  return not e.isDead
end

function EntitiesCollection:pairs()
  return fun.filter(isAlive, self.r:pairs())
end

return EntitiesCollection
