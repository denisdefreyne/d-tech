local class = require('engine.vendor.middleclass.middleclass')

local Rect = class('Rect')

local _point
local function Point()
  if not _point then _point = require('engine.types.point') end
  return _point
end

local _size
local function Size()
  if not _size then _size = require('engine.types.size') end
  return _size
end

local _range
local function Range()
  if not _range then _range = require('engine.types.range') end
  return _range
end

function Rect:initialize(x, y, width, height)
  self.origin = Point():new(x, y)
  self.size   = Size():new(width, height)
end

function Rect:collidesWith(other)
  return self:xRange():overlapsWith(other:xRange()) and self:yRange():overlapsWith(other:yRange())
end

function Rect:xRange()
  return Range():new(self:left(), self:right())
end

function Rect:yRange()
  return Range():new(self:top(), self:bottom())
end

function Rect:middle()
  return self:xMiddle(), self:yMiddle()
end

function Rect:middlePoint()
  return Point():new(
    self:xMiddle(),
    self:yMiddle()
  )
end

function Rect:xMiddle()
  return self.origin.x + self.size.width/2
end

function Rect:yMiddle()
  return self.origin.y + self.size.height/2
end

function Rect:left()
  return self.origin.x
end

function Rect:right()
  return self.origin.x + self.size.width
end

function Rect:top()
  return self.origin.y
end

function Rect:bottom()
  return self.origin.y + self.size.height
end

function Rect:isFullyBelow(other)
  return self:top() > other:bottom()
end

function Rect:isFullyAbove(other)
  return self:bottom() < other:top()
end

function Rect:isFullyLeft(other)
  return self:right() < other:left()
end

function Rect:isFullyRight(other)
  return self:left() > other:right()
end

function Rect:containsPoint(point)
  return self:xRange():includesValue(point.x) and self:yRange():includesValue(point.y)
end

function Rect:fill()
  love.graphics.rectangle(
    "fill",
    self.origin.x,
    self.origin.y,
    self.size.width,
    self.size.height)
end

function Rect:coords()
  return self:left(), self:top(), self:right(), self:bottom()
end

function Rect:__tostring()
  return string.format('(Rect %s %s)', self.origin, self.size)
end

return Rect
