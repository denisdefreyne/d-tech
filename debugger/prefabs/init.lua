local here = (...):match("(.-)[^%.]+$")

local Prefabs = {}

Prefabs.Inspector  = require(here .. 'prefabs.inspector')
Prefabs.StepButton = require(here .. 'prefabs.step_button')

return Prefabs
