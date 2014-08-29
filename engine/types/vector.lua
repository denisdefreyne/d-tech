local Vector = {}
Vector.__index = Vector

local _point
local function Point()
  if not _point then _point = require('engine.types.point') end
  return _point
end

function Vector.new(x, y)
  return setmetatable({ x = x, y = y }, Vector)
end

function Vector:dup()
  return Vector.new(self.x, self.y)
end

function Vector:invertX()
  self.x = - self.x
  return self
end

function Vector:invertY()
  self.y = - self.y
  return self
end

function Vector:limitToLength(maxLength)
  local length = self:getLength()
  if length > maxLength then
    local factor = maxLength / length
    self.x = self.x * factor
    self.y = self.y * factor
  end
end

function Vector:addVector(other)
  self.x = self.x + other.x
  self.y = self.y + other.y
end

function Vector:div(num)
  return Vector.new(self.x / num, self.y / num)
end

function Vector:asPoint()
  return Point().new(self.x, self.y)
end

function Vector:getLength()
  return math.sqrt(math.pow(self.x, 2) + math.pow(self.y, 2))
end

function Vector:scalarMultiply(scalar)
  self.x = self.x * scalar
  self.y = self.y * scalar
  return self
end

function Vector:angle()
  return math.atan2(self.y, self.x)
end

function Vector:cos()
  return math.cos(self:angle())
end

function Vector:sin()
  return math.sin(self:angle())
end

function Vector:normal1()
  return Vector.new(- self.y, self.x)
end

function Vector:normal2()
  return Vector.new(self.y, - self.x)
end

function Vector:format()
  return string.format('(%i, %i)', self.x, self.y)
end

return Vector
