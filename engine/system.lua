local here = (...):match("(.-)[^%.]+$")

local Engine_Components = require(here .. 'components')
local Signal        = require('engine.vendor.hump.signal')

local System = {}

function System.newType()
  return setmetatable({}, { __index = System })
end

function System.new(class, entities, requiredComponentTypes, signalNames)
  local t = {
    entities = entities,
    requiredComponentTypes = requiredComponentTypes,
    signalNames = signalNames or {},
    receivedSignals = {},
    signalHandles = {}
  }

  local signalReceivedFunction = function(name)
    return function(attributes)
      table.insert(t.receivedSignals, { name = name, attributes = attributes })
    end
  end

  for _, name in pairs(t.signalNames) do
    local handle = Signal.register(name, signalReceivedFunction(name))
    table.insert(t.signalHandles, { name = name, handle = handle })
  end

  return setmetatable(t, { __index = class })
end

function System:leave()
  for _, handle in pairs(self.handles) do
    Signal.remove(handle.name, handle.handle)
  end
end

local function localdt(entity, dt)
  local timewarp = entity:get(Engine_Components.Timewarp)
  if timewarp then
    return dt * timewarp.factor
  else
    return dt
  end
end

local function allComponentsPresent(entity, requiredComponentTypes)
  for _, componentType in ipairs(requiredComponentTypes) do
    if not entity:get(componentType) then
      return false
    end
  end
  return true
end

function System:update(dt)
  -- Handle signals
  if self.handleSignal then
    for _, signal in pairs(self.receivedSignals) do
      self:handleSignal(signal.name, signal.attributes)
    end
  end
  self.receivedSignals = {}

  -- Handle entities
  if self.updateEntity then
    for entity in self.entities:pairs() do
      if allComponentsPresent(entity, self.requiredComponentTypes) then
        self:updateEntity(entity, localdt(entity, dt))
      end
    end
  end
end

-- To be overridden:
--   function System:handleSignal(name, attributes)

-- To be overridden:
--   function System:updateEntity(entity, dt)

return System
