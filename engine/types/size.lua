local class  = require('engine.vendor.middleclass.middleclass')

local Size = class('Size')

function Size:initialize(width, height)
  self.width = width
  self.height = height
end

function Size:dup()
  return Size:new(self.width, self.height)
end

function Size:xMiddle()
  return self.width/2
end

function Size:yMiddle()
  return self.height/2
end

function Size:__tostring()
  return string.format('(Size %i %i)', self.width, self.height)
end

return Size
