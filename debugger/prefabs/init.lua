local here = (...):match("(.-)[^%.]+$")

local Prefabs = {}

Prefabs.Inspector   = require(here .. 'prefabs.inspector')
Prefabs.StepButton  = require(here .. 'prefabs.step_button')
Prefabs.EnterButton = require(here .. 'prefabs.enter_button')

return Prefabs
