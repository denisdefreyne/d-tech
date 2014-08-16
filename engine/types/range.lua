local Range = {}
Range.__index = Range

function Range.new(min, max)
  return setmetatable({ min = min, max = max }, Range)
end

function Range:includesValue(value)
  return value >= self.min and value <= self.max
end

function Range:overlapsWith(other)
  return self:includesValue(other.min) or other:includesValue(self.min)
end

return Range
