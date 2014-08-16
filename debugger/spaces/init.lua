local here = (...):match("(.-)[^%.]+$")

local Spaces = {}

Spaces.Arena = require(here .. 'spaces.arena')
Spaces.GUI   = require(here .. 'spaces.gui')

return Spaces
