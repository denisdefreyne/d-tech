local Rendering = {}
Rendering.__index = Rendering

local Engine_AssetManager = require('engine.asset_manager')
local Engine_Helper       = require('engine.helper')
local Engine_Components   = require('engine.components')

local lg = love.graphics
local lw = love.window

-- Sorts the entities in the given table `t` by their `z` component.
local function ipairsSortedByZ(t)
  local keys = {}
  for k in t:pairs() do
    if k:get(Engine_Components.Z) then
      keys[#keys+1] = k
    end
  end

  local compareByZ = function(entityA, entityB)
    local az = entityA:get(Engine_Components.Z)
    local bz = entityB:get(Engine_Components.Z)
    return az.value < bz.value
  end

  table.sort(keys, compareByZ)

  local i = 0
  return function()
    i = i + 1
    if keys[i] then
      return keys[i], t[keys[i]]
    end
  end
end

local function translateToAnchorPoint(entity)
  local size = Engine_Helper.sizeForEntity(entity)
  if not size then return end

  local anchorPoint = entity:get(Engine_Components.AnchorPoint)
  local x = anchorPoint and anchorPoint.x or 0.5
  local y = anchorPoint and anchorPoint.y or 0.5

  lg.translate(-size.width * x, -size.height * y)
end

local function rotate(entity)
  local rotation = entity:get(Engine_Components.Rotation)
  if rotation then
    lg.rotate(rotation.value)
  end
end

local function scale(entity)
  local scale = entity:get(Engine_Components.Scale)
  if scale then
    lg.scale(scale.value)
  end
end

function Rendering.new(entities)
  -- TODO: Find all image components and cache them here
  return setmetatable({ entities = entities }, Rendering)
end

function Rendering:draw()
  local camera = self.entities:firstWithComponent(Engine_Components.Camera)
  local cameraPosition = camera and camera:get(Engine_Components.Position) or nil
  if cameraPosition then
    lg.push()
    lg.translate(-cameraPosition.x, -cameraPosition.y)
    lg.translate(lw.getWidth()/2, lw.getHeight()/2)
  end

  love.graphics.setColor(255, 255, 255, 255)
  for entity in ipairsSortedByZ(self.entities) do
    self:drawEntity(entity)
  end

  if cameraPosition then
    lg.pop()
  end
end

function Rendering:drawEntity(entity)
  local position = entity:get(Engine_Components.Position)
  if not position then return end

  lg.push()

  lg.translate(position.x, position.y)
  rotate(entity)
  translateToAnchorPoint(entity)
  scale(entity)

  self:drawEntitySimple(entity)

  lg.pop()
end

function Rendering:drawEntitySimple(entity)
  local image = entity:get(Engine_Components.Image)
  if image then
    lg.draw(Engine_AssetManager.image(image.path))
    return
  end

  local particleSystem = entity:get(Engine_Components.ParticleSystem)
  if particleSystem then
    lg.draw(particleSystem.wrapped)
    return
  end

  local renderer = entity:get(Engine_Components.Renderer)
  if renderer then
    local rendererClass = Engine_Helper.rendererNamed(renderer.name)
    rendererClass.draw(entity)
  end
end

return Rendering
