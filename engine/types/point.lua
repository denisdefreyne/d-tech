local Point = {}

local Signal            = require('engine.vendor.hump.signal')

local mt = {}

Point.__index = mt
Point.__newindex = function(table, key, value)
  print 'hi'
end

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

function mt:dup()
  return mt.new(self.x, self.y)
end

function mt:asVector()
  if not Vector then Vector = require('engine.types.vector') end
  return Vector().new(self.x, self.y)
end

function mt:vectorTo(other)
  if not Vector then Vector = require('engine.types.vector') end
  return Vector().new(other.x - self.x, other.y - self.y)
end

function mt:addVector(vector)
  self.x = self.x + vector.x
  self.y = self.y + vector.y
end

function mt:format()
  return string.format('(%i, %i)', self.x, self.y)
end

return Point
