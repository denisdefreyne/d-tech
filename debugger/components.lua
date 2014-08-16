local Components = {}

Components.SelectionTracker = {
  order  = 0,
  name   = 'Selected entity',
  new    = function() return { selectedEntity = nil } end,
  format = function(self) return self.selectedEntity and 'something' or 'nothing' end,
}

Components.Label = {
  order  = 1,
  name   = 'Label',
  new    = function(string) return { string = string } end,
  format = function(self) return self.string end,
}

Components.CursorTracking = {
  order  = 2,
  name   = 'Cursor tracking',
  new    = function() return { hover = false, down = false } end,
  format = function(self) return 'Hover: ' .. (self.hover and 'yes' or 'no') .. '; down: ' .. (self.down and 'yes' or 'no') end,
}

Components.Movable = {
  order  = 4,
  name   = 'Movable',
  new    = function() return {} end,
  format = function(self) return 'Yes' end,
}

Components.StepBehavior = {
  order  = 5,
  name   = 'Step behavior',
  new    = function() return {} end,
  format = function(self) return 'Yes' end,
}

return Components
