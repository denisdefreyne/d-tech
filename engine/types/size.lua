local Size = {}
Size.__index = Size

function Size.new(width, height)
  return setmetatable({ width = width, height = height }, Size)
end

function Size:dup()
  return Size.new(self.width, self.height)
end

function Size:xMiddle()
  return self.width/2
end

function Size:yMiddle()
  return self.height/2
end

function Size:format()
  return string.format('(%i, %i)', self.width, self.height)
end

return Size
