local class = require('engine.vendor.middleclass.middleclass')
local fun = require('engine.vendor.luafun.fun')

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

function Set:empty()
  self.vals = {}
end

function Set:pairs()
  return fun.iter(self.vals)
end

function Set:__tostring()
  return string.format('(Set)')
end

return Set
