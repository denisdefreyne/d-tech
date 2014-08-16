local here = (...):match("(.-)[^%.]+$")

local Engine_Components = require(here .. 'components')

local System = {}

function System.newType()
  return setmetatable({}, { __index = System })
end

function System.new(class, entities, requiredComponentTypes)
  local t = {
    entities = entities,
    requiredComponentTypes = requiredComponentTypes,
  }

  return setmetatable(t, { __index = class })
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
  for entity in self.entities:pairs() do
    if allComponentsPresent(entity, self.requiredComponentTypes) then
      self:updateEntity(entity, localdt(entity, dt))
    end
  end
end

function System:updateEntity(entity, dt)
  -- To be overridden
end

return System
