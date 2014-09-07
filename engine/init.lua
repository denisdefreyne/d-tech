local here = (...):match("(.-)[^%.]+$")

local Engine = {}

Engine.Types        = require(here .. 'engine.types')
Engine.AssetManager = require(here .. 'engine.asset_manager')
Engine.Gamestate    = require(here .. 'engine.gamestate')
Engine.Space        = require(here .. 'engine.space')
Engine.Entity       = require(here .. 'engine.entity')
Engine.Components   = require(here .. 'engine.components')
Engine.Systems      = require(here .. 'engine.systems')
Engine.System       = require(here .. 'engine.system')

local Helper = require(here .. 'engine.helper')
Engine.rectForEntity    = Helper.rectForEntity
Engine.sizeForEntity    = Helper.sizeForEntity
Engine.registerRenderer = Helper.registerRenderer
Engine.rendererNamed    = Helper.rendererNamed
Engine.screenToWorld    = Helper.screenToWorld
Engine.entityAtPosition = Helper.entityAtPosition

return Engine
