local here = (...):match("(.-)[^%.]+$")

local Types = {}

Types.Angle              = require(here .. 'types.angle')
Types.EntitiesCollection = require(here .. 'types.entities_collection')
Types.Point              = require(here .. 'types.point')
Types.Range              = require(here .. 'types.range')
Types.Rect               = require(here .. 'types.rect')
Types.Set                = require(here .. 'types.set')
Types.Size               = require(here .. 'types.size')
Types.Vector             = require(here .. 'types.vector')

return Types
