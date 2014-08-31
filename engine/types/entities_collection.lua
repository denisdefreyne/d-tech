local EntitiesCollection = {}
EntitiesCollection.__index = EntitiesCollection

local Signal = require('engine.vendor.hump.signal')

local _set
local function Set()
  if not _set then _set = require('engine.types.set') end
  return _set
end

EntitiesCollection.ADD_SIGNAL    = 'engine:types:entities_collection:added'
EntitiesCollection.REMOVE_SIGNAL = 'engine:types:entities_collection:removed'

function EntitiesCollection.new()
  local t = {
    r = Set().new(),
    removeCallbacks = Set().new(),
    addCallbacks    = Set().new(),
  }

  return setmetatable(t, EntitiesCollection)
end

function EntitiesCollection:replaceEntities(r)
  self.r = Set().new()
  for entity in r:pairs() do
    self:add(entity)
  end
end

function EntitiesCollection:add(entity)
  self.r:add(entity)
  Signal.emit(EntitiesCollection.ADD_SIGNAL, entity, self)
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
  Signal.emit(EntitiesCollection.REMOVE_SIGNAL, entity, self)
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
