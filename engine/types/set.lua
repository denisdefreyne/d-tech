local Set = {}
Set.__index = Set

function Set.new()
  return setmetatable({ vals = {}, size = 0 }, Set)
end

function Set:add(e)
  if not self.vals[e] then self.size = self.size + 1 end
  self.vals[e] = true
end

function Set:remove(e)
  self.vals[e] = nil
  self.size = self.size - 1
end

function Set:each()
  return pairs(self.vals)
end

function Set:pairs()
  return pairs(self.vals)
end

return Set
