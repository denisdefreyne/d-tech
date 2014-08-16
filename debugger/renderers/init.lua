local Engine = require('engine')

local Inspector = require('debugger.renderers.inspector')
Engine.registerRenderer('Inspector', Inspector)

local Button = require('debugger.renderers.button')
Engine.registerRenderer('Button', Button)
