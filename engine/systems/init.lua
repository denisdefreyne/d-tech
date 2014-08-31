local here = (...):match("(.-)[^%.]+$")

local Systems = {}

Systems.Animation          = require(here .. 'systems.animation')
Systems.CollisionDetection = require(here .. 'systems.collision_detection')
Systems.Rendering          = require(here .. 'systems.rendering')
Systems.Physics            = require(here .. 'systems.physics')
Systems.Sound              = require(here .. 'systems.sound')
Systems.ParticleSystem     = require(here .. 'systems.particle_system')
Systems.Lifetime           = require(here .. 'systems.lifetime')

return Systems
