local Point = {}
Point.__index = Point

local _vector
local function Vector()
  if not _vector then _vector = require('engine.types.vector') end
  return _vector
end

function Point.new(x, y)
  return setmetatable({ x = x, y = y }, Point)
end

function Point:dup()
  return Point.new(self.x, self.y)
end

function Point:asVector()
  if not Vector then Vector = require('engine.types.vector') end
  return Vector().new(self.x, self.y)
end

function Point:vectorTo(other)
  if not Vector then Vector = require('engine.types.vector') end
  return Vector().new(other.x - self.x, other.y - self.y)
end

function Point:addVector(vector)
  self.x = self.x + vector.x
  self.y = self.y + vector.y
end

function Point:format()
  return string.format('(%i, %i)', self.x, self.y)
end

return Point
