require('engine_spec.helper')

local Engine = require('engine')

describe("Physics system", function()
  local blankEntity
  local entityWithPosition
  local entityWithVelocity
  local entityWithPositionAndVelocity
  local entities
  local subject

  before_each(function()
     blankEntity = Engine.Entity.new()

     entityWithPosition = Engine.Entity.new()
     entityWithPosition:add(Engine.Components.Position, 200, 400)

     entityWithVelocity = Engine.Entity.new()
     entityWithVelocity:add(Engine.Components.Velocity, 30, 40)

     entityWithPositionAndVelocity = Engine.Entity.new()
     entityWithPositionAndVelocity:add(Engine.Components.Position, 100, 300)
     entityWithPositionAndVelocity:add(Engine.Components.Velocity, 10, 20)

     entities = Engine.Types.EntitiesCollection:new()
     entities:add(blankEntity)
     entities:add(entityWithPosition)
     entities:add(entityWithVelocity)
     entities:add(entityWithPositionAndVelocity)

     subject = Engine.Systems.Physics.new(entities)
  end)

  it("does stuff", function()
    assert.are.same(entityWithPositionAndVelocity:get(Engine.Components.Position).x, 100)
    assert.are.same(entityWithPositionAndVelocity:get(Engine.Components.Position).y, 300)

    subject:update(0.5)

    assert.are.same(entityWithPositionAndVelocity:get(Engine.Components.Position).x, 100 + 0.5*10)
    assert.are.same(entityWithPositionAndVelocity:get(Engine.Components.Position).y, 300 + 0.5*20)
  end)
end)
