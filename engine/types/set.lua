local class = require('engine.vendor.middleclass.middleclass')

local Set = class('Set')

function Set:initialize()
  self.vals = {}
end

function Set:add(e)
  self.vals[e] = true
end

function Set:remove(e)
  self.vals[e] = nil
end

function Set:pairs()
  return pairs(self.vals)
end

function Set:__tostring()
  return string.format('(Set)')
end

return Set
