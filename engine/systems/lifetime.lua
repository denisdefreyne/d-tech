local Engine_Components = require('engine.components')
local Engine_System     = require('engine.system')

local Lifetime = Engine_System.newType()

function Lifetime.new(entities)
  local requiredComponentTypes = {
    Engine_Components.Lifetime,
  }

  return Engine_System.new(Lifetime, entities, requiredComponentTypes)
end

function Lifetime:updateEntity(entity, dt)
  local lifetime = entity:get(Engine_Components.Lifetime)

  lifetime.value = lifetime.value + dt
end

return Lifetime
