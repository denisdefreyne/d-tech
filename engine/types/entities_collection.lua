local EntitiesCollection = {}
EntitiesCollection.__index = EntitiesCollection

local _set
local function Set()
  if not _set then _set = require('engine.types.set') end
  return _set
end

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

function EntitiesCollection:addAddCallback(fn)
  self.addCallbacks:add(fn)
end

function EntitiesCollection:removeAddCallback(fn)
  self.addCallbacks:remove(fn)
end

function EntitiesCollection:addRemoveCallback(fn)
  self.removeCallbacks:add(fn)
end

function EntitiesCollection:removeRemoveCallback(fn)
  self.removeCallbacks:remove(fn)
end

function EntitiesCollection:add(entity)
  self.r:add(entity)
  for fn in self.addCallbacks:pairs() do fn(entity) end
end

function EntitiesCollection:firstWithComponent(componentType)
  return self:firstWithComponents({ componentType })
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
  for fn in self.removeCallbacks:pairs() do fn(entity) end
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
