local class  = require('engine.vendor.middleclass.middleclass')
local Signal = require('engine.vendor.hump.signal')

local Point = class('Point')

local _vector
local function Vector()
  if not _vector then _vector = require('engine.types.vector') end
  return _vector
end

function Point:initialize(x, y, signal)
  self.x = x
  self.y = y
  self.signal = signal
end

function Point:dup()
  return Point:new(self.x, self.y)
end

function Point:update(x, y)
  local dx, dy = x - self.x, y - self.y

  self.x, self.y = x, y

  if self.signal then
    Signal.emit(self.signal, { component = self, dx = dx, dy = dy })
  end
end

function Point:updateRelative(dx, dy)
  self.x, self.y = self.x + dx, self.y + dy

  if self.signal then
    Signal.emit(self.signal, { component = self, dx = dx, dy = dy })
  end
end

function Point:asVector()
  return Vector():new(self.x, self.y)
end

function Point:vectorTo(other)
  return Vector():new(other.x - self.x, other.y - self.y)
end

function Point:addVector(vector)
  self:update(
    self.x + vector.x,
    self.y + vector.y)
end

function Point:__tostring()
  return string.format('(Point %i %i)', self.x, self.y)
end

return Point
