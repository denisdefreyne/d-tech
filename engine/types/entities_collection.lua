local class = require('engine.vendor.middleclass.middleclass')
local fun = require('engine.vendor.luafun.fun')

local EntitiesCollection = class('EntitiesCollection')

local Signal = require('engine.vendor.hump.signal')

local _set
local function Set()
  if not _set then _set = require('engine.types.set') end
  return _set
end

EntitiesCollection.ENTITY_ADDED_SIGNAL   = 'engine:types:entities_collection:added'
EntitiesCollection.ENTITY_REMOVED_SIGNAL = 'engine:types:entities_collection:removed'

function EntitiesCollection:initialize()
  self.r = Set():new()
  self.dead = Set():new()
end

function EntitiesCollection:add(entity)
  self.r:add(entity)
  Signal.emit(
    EntitiesCollection.ENTITY_ADDED_SIGNAL,
    { entity = entity, entityCollection = self })
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
    { entity = entity, entityCollection = self })

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
