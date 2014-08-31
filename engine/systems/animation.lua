local Engine_Components = require('engine.components')
local Engine_System     = require('engine.system')

local Animation = Engine_System.newType()

function Animation.new(entities)
  local requiredComponentTypes = {
    Engine_Components.Animation,
  }

  return Engine_System.new(Animation, entities, requiredComponentTypes)
end

function Animation:updateEntity(entity, dt)
  local animation = entity:get(Engine_Components.Animation)

  animation.curDelay = animation.curDelay + dt
  if animation.curDelay > animation.delay then
    animation.curDelay = animation.curDelay - animation.delay

    animation.curFrame = animation.curFrame + 1
    if animation.curFrame > #animation.imagePaths then
      animation.curFrame = 1
    end
  end
end

return Animation
