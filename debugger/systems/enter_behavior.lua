local EnterBehavior = {}
EnterBehavior.__index = EnterBehavior

local Engine    = require('engine')
local Signal    = require('engine.vendor.hump.signal')
local Gamestate = require('engine.vendor.hump.gamestate')
local Debugger_Components = require('debugger.components')

function EnterBehavior.new(entities)
  local t = {
    entities = entities,
    callbacks = {}
  }

  local clickCallback = function(entity)
    local selectionTracker = entity:get(Debugger_Components.SelectionTracker)
    local selectedEntity = selectionTracker and selectionTracker.selectedEntity
    local viewportComponent = selectedEntity and selectedEntity:get(Engine.Components.Viewport)

    print('selectionTracker', selectionTracker)
    print('selectedEntity', selectedEntity)
    print('viewportComponent', viewportComponent)

    if viewportComponent then
      local Debugger_Gamestate = require('debugger.gamestate')
      Gamestate.switch(Debugger_Gamestate.new(viewportComponent.entities))
    end
  end
  t.callbacks.clickCallback = clickCallback
  Signal.register('debugger:systems:cursor-tracking:clicked', clickCallback)

  return setmetatable(t, EnterBehavior)
end

function EnterBehavior:leave()
  Signal.remove('debugger:systems:cursor-tracking:clicked', self.callbacks.clickCallback)
end

function EnterBehavior:update(dt)
end

return EnterBehavior
