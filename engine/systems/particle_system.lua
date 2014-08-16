local Engine_AssetManager = require('engine.asset_manager')
local Engine_Components = require('engine.components')
local Engine_System     = require('engine.system')

local ParticleSystem = Engine_System.newType()

function ParticleSystem.new(entities)
  local requiredComponentTypes = {
    Engine_Components.ParticleSystem,
  }

  return Engine_System.new(ParticleSystem, entities, requiredComponentTypes)
end

function ParticleSystem:updateEntity(entity, dt)
  local particleSystem = entity:get(Engine_Components.ParticleSystem)

  -- FIXME: Storing this inside the component itself may cause issues later on
  if not particleSystem.wrapped then
    local img = Engine_AssetManager.image(particleSystem.imagePath)
    local ps = love.graphics.newParticleSystem(img)

    ps:setPosition(unpack(particleSystem.config.position))
    ps:setOffset(unpack(particleSystem.config.offset))
    ps:setBufferSize(particleSystem.config.bufferSize)
    ps:setEmissionRate(particleSystem.config.emissionRate)
    ps:setEmitterLifetime(particleSystem.config.emitterLifetime)
    ps:setParticleLifetime(unpack(particleSystem.config.particleLifetime))
    ps:setColors(unpack(particleSystem.config.colors))
    ps:setSizes(unpack(particleSystem.config.sizes))
    ps:setSizeVariation(particleSystem.config.sizeVariation)
    ps:setSpeed(unpack(particleSystem.config.speed))
    ps:setDirection(particleSystem.config.direction)
    ps:setSpread(particleSystem.config.spread)
    ps:setLinearAcceleration(unpack(particleSystem.config.linearAcceleration))
    ps:setRotation(unpack(particleSystem.config.rotation))
    ps:setSpin(unpack(particleSystem.config.spin))
    ps:setRadialAcceleration(particleSystem.config.radialAcceleration)
    ps:setTangentialAcceleration(particleSystem.config.tangentialAcceleration)

    ps:start()

    particleSystem.wrapped = ps
  end

  particleSystem.wrapped:update(dt)

  if particleSystem.removeOnComplete and particleSystem.wrapped:getCount() == 0 then
    self.entities:remove(entity)
    return
  end
end

return ParticleSystem
