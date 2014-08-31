local class = require('engine.vendor.middleclass.middleclass')

local Range = class('Range')

function Range:initialize(min, max)
  self.min = min
  self.max = max
end

function Range:includesValue(value)
  return value >= self.min and value <= self.max
end

function Range:overlapsWith(other)
  return self:includesValue(other.min) or other:includesValue(self.min)
end

function Range:__tostring()
  return string.format('(Range %i %i)', self.min, self.max)
end

return Range
