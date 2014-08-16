local Engine_AssetManager = require('engine.asset_manager')
local Engine_Components   = require('engine.components')

local Sound = {}
Sound.__index = Sound

function Sound.new(entities)
  t = {
    entities = entities,
  }

  t.addCallback = function(entity)
    local soundComponent = entity:get(Engine_Components.Sound)
    if soundComponent then
      -- FIXME: LÖVE does not allow a single sound to be played multiple times
      -- simultaneously, but SLAM (https://github.com/vrld/slam) fixes that.
      local sound = Engine_AssetManager.sound(soundComponent.path)
      sound:play()
    end
  end
  entities:addAddCallback(t.addCallback)

  return setmetatable(t, Sound)
end

function Sound:leave()
  self.entities:removeAddCallback(t.addCallback)
end

return Sound
