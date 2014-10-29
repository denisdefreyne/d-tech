local here = (...):match("(.-)[^%.]+$")

local Engine_Types = require(here .. 'types')

local Components = {}

-- `fn` receives entity, dt, entities
Components.WhileAlive = {
  new = function(fn) return { fn = fn } end,
}

-- `fn` receives key, entity, dt, entities
Components.WhileKeyDown = {
  new = function(keys, fn) return { keys = keys, fn = fn } end,
}

-- `fn` receives key, entity, dt, entities
Components.OnKeyDown = {
  new = function(keys, fn) return { keys = keys, fn = fn } end,
}

local positionSignal = 'engine:components:position:updated'
Components.Position = {
  new = function(x, y) return Engine_Types.Point:new(x, y, positionSignal) end,
  UPDATED_SIGNAL = positionSignal,
}

Components.AnchorPoint = {
  new = function(x, y) return Engine_Types.Point:new(x, y) end,
}

Components.Velocity = {
  new = function(x, y) return Engine_Types.Vector:new(x, y) end,
}

Components.Friction = {
  new = function(f) return { f = f } end,
}

Components.Scale = {
  new = function(x, y) return { x = x, y = y } end,
}

Components.Z = {
  new = function(value) return { value = value } end,
}

Components.Rotation = {
  new = function(value) return { value = value } end,
}

Components.Size = {
  new = function(w, h) return Engine_Types.Size:new(w, h) end,
}

Components.Image = {
  new = function(path) return { path = path } end,
}

Components.ImageQuad = {
  new = function(path, x, y, width, height) return { path = path, x = x, y = y, width = width, height = height } end,
}

-- TODO: At some point, we’ll probably need destroy-on-finish sounds
Components.Sound = {
  new = function(path) return { path = path } end,
}

Components.ParticleSystem = {
  new = function(imagePath, config, removeOnComplete) return { imagePath = imagePath, config = config, removeOnComplete = removeOnComplete } end,
}

Components.Renderer = {
  new = function(name) return { name = name } end,
}

Components.Timewarp = {
  new = function() return { factor = 1.0 } end,
}

Components.Lifetime = {
  new = function() return { value = 0.0 } end,
}

Components.Button = {
  new = function(label) return { label = label } end,
}

-- `fn` receives entity, entities, x, y, button
Components.OnClick = {
  new = function(fn) return { fn = fn } end
}

-- `fn` receives entity, dt, entities
Components.WhileMouseDown = {
  new = function(fn) return { fn = fn } end,
}

Components.CursorTracking = {
  new = function() return { isHovering = false, isDown = false } end
}

Components.Viewport = {
  new = function(camera, entities) return { camera = camera, entities = entities } end,
}

Components.Camera = {
  new = function() return {} end,
}

Components.Animation = {
  new = function(imagePaths, delay) return { imagePaths = imagePaths, delay = delay, curFrame = 1, curDelay = 0 } end,
}

-- `fn` receives entity, other entity, and entity collection
Components.OnCollide = {
  new = function(fn) return { fn = fn } end
}

-- `fn` receives entity, button
Components.OnMouseWheelMoved = {
  new = function(fn) return { fn = fn } end
}

Components.Outline = {
  new = function() return {} end
}

return Components
