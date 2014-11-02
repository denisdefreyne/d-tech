local Signal = require('engine.vendor.hump.signal')
local Set = require('engine.types.set')

local ComponentIndex = {}
ComponentIndex.__index = ComponentIndex

function ComponentIndex.new(entities)
  local new = setmetatable({ entities = entities }, ComponentIndex)

  local E_T_EC = require('engine.types.entities_collection')
  local E_E    = require('engine.entity')

  local signalNames = {
    E_T_EC.ENTITY_ADDED_SIGNAL,
    E_T_EC.ENTITY_REMOVED_SIGNAL,
    E_E.COMPONENT_ADDED_SIGNAL,
    E_E.COMPONENT_REMOVED_SIGNAL,
  }

  local signalHandles = {}

  local wrap = function(name, fn, self)
    return function(attributes)
      fn(self, name, attributes)
    end
  end

  for _, name in pairs(signalNames) do
    local handle = Signal.register(name, wrap(name, ComponentIndex.handleSignal, new))
    table.insert(signalHandles, { name = name, handle = handle })
  end

  return new
end

function ComponentIndex:leave()
  for _, handle in pairs(self.signalHandles) do
    Signal.remove(handle.name, handle.handle)
  end
end

function ComponentIndex:queryComponentType(componentType)
  return self.componentSets[componentType] or Set:new()
end

function ComponentIndex:handleSignal(name, attributes)
  if not self.componentSets then
    self.componentSets = {}
  end

  local E_T_EC = require('engine.types.entities_collection')
  local E_E    = require('engine.entity')

  local entity = attributes.entity
  local component = attributes.component
  local componentType = attributes.componentType

  if not self.entities:contains(entity) then return end

  if name == E_T_EC.ENTITY_ADDED_SIGNAL then
    -- Add to all appropriate sets
    for componentType, _ in pairs(entity) do
      local componentSet = self.componentSets[componentType]
      if not componentSet then
        self.componentSets[componentType] = Set:new()
        componentSet = self.componentSets[componentType]
      end

      -- Add to appropriate set
      componentSet:add(entity)
    end
  elseif name == E_T_EC.ENTITY_REMOVED_SIGNAL then
    -- Remove from all sets
    for _, componentSet in ipairs(self.componentSets) do
      componentSet:remove(entity)
    end
  elseif name == E_E.COMPONENT_ADDED_SIGNAL then
    -- Create component set if necessary
    local componentSet = self.componentSets[componentType]
    if not componentSet then
      self.componentSets[componentType] = Set:new()
      componentSet = self.componentSets[componentType]
    end

    -- Add to appropriate set
    componentSet:add(entity)
  elseif name == E_E.COMPONENT_REMOVED_SIGNAL then
    local componentSet = self.componentSets[componentType]
    if componentSet then
      componentSet:remove(entity)
    end
  else
    error('Does not exist')
  end
end

return ComponentIndex
