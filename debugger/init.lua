local here = (...):match("(.-)[^%.]+$")

require(here .. 'debugger.renderers')

local Debugger = {}

Debugger.Gamestate  = require(here .. 'debugger.gamestate')

return Debugger
