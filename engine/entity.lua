local here = (...):match("(.-)[^%.]+$")

local Entity = setmetatable({}, { __index = function() error('Attempted to access non-existant entity attribute') end })

function Entity.new()
  return setmetatable({}, { __index = Entity })
end

-- e.g. `ship:add(Engine.Components.Position, true)`
function Entity:add(type, ...)
  self[type] = type.new(...)
end

-- e.g. `ship:get(Engine.Components.Position)`
function Entity:get(type)
  return rawget(self, type)
end

return Entity
