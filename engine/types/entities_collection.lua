local class = require('engine.vendor.middleclass.middleclass')

local EntitiesCollection = class('EntitiesCollection')

local Signal = require('engine.vendor.hump.signal')

local _set
local function Set()
  if not _set then _set = require('engine.types.set') end
  return _set
end

EntitiesCollection.ADD_SIGNAL    = 'engine:types:entities_collection:added'
EntitiesCollection.REMOVE_SIGNAL = 'engine:types:entities_collection:removed'

function EntitiesCollection:initialize()
  self.r = Set():new()
end

function EntitiesCollection:add(entity)
  self.r:add(entity)
  Signal.emit(
    EntitiesCollection.ADD_SIGNAL,
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
    EntitiesCollection.REMOVE_SIGNAL,
    { entity = entity, entityCollection = self })
  self.r:remove(entity)
end

function EntitiesCollection:find(fn)
  for e in self:pairs() do
    if fn(e) then return e end
  end
  return nil
end

function EntitiesCollection:pairs()
  return self.r:pairs()
end

return EntitiesCollection
