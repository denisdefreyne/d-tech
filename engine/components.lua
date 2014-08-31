local here = (...):match("(.-)[^%.]+$")

local Engine_Types = require(here .. 'types')

local Components = {}

Components.Description = {
  new    = function(s) return { string = s } end,
}

Components.Input = {
  new    = function() return {} end,
}

local positionSignal = 'engine:components:position:updated'
Components.Position = {
  new    = function(x, y) return Engine_Types.Point.new(x, y, positionSignal) end,
  signal = positionSignal,
}

Components.AnchorPoint = {
  new    = function(x, y) return Engine_Types.Point.new(x, y) end,
}

Components.Velocity = {
  new    = function(x, y) return Engine_Types.Vector.new(x, y) end,
}

Components.Scale = {
  new    = function(x, y) return { x = x, y = y } end,
}

Components.Z = {
  new    = function(value) return { value = value } end,
}

Components.Rotation = {
  new    = function(value) return { value = value } end,
}

Components.Size = {
  new    = function(w, h) return Engine_Types.Size.new(w, h) end,
}

Components.Image = {
  new    = function(path) return { path = path } end,
}

-- TODO: At some point, we’ll probably need destroy-on-finish sounds
Components.Sound = {
  new    = function(path) return { path = path } end,
}

Components.ParticleSystem = {
  new    = function(imagePath, config, removeOnComplete) return { imagePath = imagePath, config = config, removeOnComplete = removeOnComplete } end,
}

Components.Renderer = {
  new    = function(name) return { name = name } end,
}

Components.Camera = {
  new    = function() return {} end,
}

Components.Timewarp = {
  new    = function() return { factor = 1.0 } end,
}

Components.Lifetime = {
  new    = function() return { value = 0.0 } end,
}

Components.Button = {
  new    = function(label, name) return { label = label, name = name } end,
}

Components.CollisionGroup = {
  new    = function(name) return { name = name } end,
}

Components.Viewport = {
  new    = function(camera, entities) return { camera = camera, entities = entities } end,
}

Components.Animation = {
  new    = function(imagePaths, delay) return { imagePaths = imagePaths, delay = delay, curFrame = 1, curDelay = 0 } end,
}

return Components
