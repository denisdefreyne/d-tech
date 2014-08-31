local Point = {}

local Signal = require('engine.vendor.hump.signal')

local mt = {}

local _vector
local function Vector()
  if not _vector then _vector = require('engine.types.vector') end
  return _vector
end

function Point.new(x, y, signal)
  return setmetatable({ props = { x = x, y = y, signal = signal } }, mt)
end

function mt:__index(key)
  if self.props[key] ~= nil then
    return self.props[key]
  else
    return Point[key]
  end
end

function mt:__newindex(key, value)
  local oldX, oldY = self.props.x, self.props.y
  rawset(self.props, key, value)
  local dx, dy = self.props.x - oldX, self.props.y - oldY

  if self.signal then
    Signal.emit(self.signal, { component = self, dx = dx, dy = dy })
  end
end

function Point:dup()
  return Point.new(self.x, self.y)
end

function Point:asVector()
  return Vector().new(self.x, self.y)
end

function Point:vectorTo(other)
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
