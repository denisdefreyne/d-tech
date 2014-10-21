local Signal = require('engine.vendor.hump.signal')
local Engine_Components = require('engine.components')
local Engine_System     = require('engine.system')

local Physics = Engine_System.newType()

function Physics.new(entities)
  local requiredComponentTypes = {
    Engine_Components.Position,
    Engine_Components.Velocity,
  }

  return Engine_System.new(Physics, entities, requiredComponentTypes)
end

function Physics:updateEntity(entity, dt)
  local position = entity:get(Engine_Components.Position)
  local velocity = entity:get(Engine_Components.Velocity)
  local friction = entity:get(Engine_Components.Friction)

  if friction then
    velocity.x = velocity.x * (1 - dt * friction.f)
    velocity.y = velocity.y * (1 - dt * friction.f)
  end

  local dx = velocity.x * dt
  local dy = velocity.y * dt

  position:update(
    position.x + dx,
    position.y + dy)
end

return Physics
