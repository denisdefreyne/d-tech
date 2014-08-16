local here = (...):match("(.-)[^%.]+$")

local Engine_Types = require(here .. 'types')

local Components = {}

Components.Description = {
  order  = -100,
  name   = 'Description',
  new    = function(s) return { string = s } end,
  format = function(self) return self.string end,
}

Components.Input = {
  order  = -99,
  name   = 'Accepts input?',
  new    = function() return {} end,
  format = function(self) return 'Yes' end,
}

Components.Position = {
  order  = -98,
  name   = 'Position',
  new    = function(x, y) return Engine_Types.Point.new(x, y) end,
  format = function(self) return self:format() end,
}

Components.AnchorPoint = {
  order  = -97,
  name   = 'Anchor point',
  new    = function(x, y) return Engine_Types.Point.new(x, y) end,
  format = function(self) return self:format() end,
}

Components.Velocity = {
  order  = -96,
  name   = 'Velocity',
  new    = function(x, y) return Engine_Types.Vector.new(x, y) end,
  format = function(self) return self:format() end,
}

Components.Scale = {
  order  = -95,
  name   = 'Scale',
  new    = function(value) return { value = value } end,
  format = function(self) return string.format('%3.2f', self.value) end,
}

Components.Z = {
  order  = -94,
  name   = 'Z index',
  new    = function(value) return { value = value } end,
  format = function(self) return string.format('%i', self.value) end,
}

Components.Rotation = {
  order  = -93,
  name   = 'Rotation',
  new    = function(value) return { value = value } end,
  format = function(self) return string.format('%3.2f (%i°)', self.value, math.deg(self.value)) end,
}

Components.Size = {
  order  = -92,
  name   = 'Size',
  new    = function(w, h) return Engine_Types.Size.new(w, h) end,
  format = function(self) return self:format() end,
}

Components.Image = {
  order  = -91,
  name   = 'Image path',
  new    = function(path) return { path = path } end,
  format = function(self) return self.path end,
}

-- TODO: At some point, we’ll probably need destroy-on-finish sounds
Components.Sound = {
  order  = -90,
  name   = 'Sound path',
  new    = function(path) return { path = path } end,
  format = function(self) return self.path end,
}

Components.ParticleSystem = {
  order  = -89,
  name   = 'Particle system',
  new    = function(imagePath, config, removeOnComplete) return { imagePath = imagePath, config = config, removeOnComplete = removeOnComplete } end,
  format = function(self) return '(lots of details here)' end,
}

Components.Renderer = {
  order  = -88,
  name   = 'Renderer',
  new    = function(name) return { name = name } end,
  format = function(self) return self.name end,
}

Components.Camera = {
  order  = -87,
  name   = 'Camera',
  new    = function() return {} end,
  format = function(self) return '-' end,
}

Components.Timewarp = {
  order  = -86,
  name   = 'Timewarp factor',
  new    = function() return { factor = 1.0 } end,
  format = function(self) return string.format('%3.1f', self.factor) end,
}

Components.Lifetime = {
  order  = -85,
  name   = 'Lifetime (s)',
  new    = function() return { value = 0.0 } end,
  format = function(self) return string.format('%3.1f', self.value) end,
}

Components.Button = {
  order  = -84,
  name   = 'Button',
  new    = function(label, name) return { label = label, name = name } end,
  format = function(self) return self.name end,
}

return Components
