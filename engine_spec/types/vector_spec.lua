require('engine_spec.helper')

local Vector = require('engine.types.vector')

describe('Vector', function()
  local subject

  before_each(function()
    subject = Vector.new(2, 5)
  end)

  describe('invertX', function()
    it('inverts', function()
      assert.are.same(subject.x, 2)
      assert.are.same(subject.y, 5)

      local res = subject:invertX()
      assert.are.equals(res, nil)

      assert.are.same(subject.x, -2)
      assert.are.same(subject.y, 5)
    end)
  end)

  describe('invertY', function()
    it('inverts', function()
      assert.are.same(subject.x, 2)
      assert.are.same(subject.y, 5)

      local res = subject:invertY()
      assert.are.equals(res, nil)

      assert.are.same(subject.x, 2)
      assert.are.same(subject.y, -5)
    end)
  end)
end)
