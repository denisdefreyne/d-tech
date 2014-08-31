local Rendering = {}
Rendering.__index = Rendering

local Engine_AssetManager = require('engine.asset_manager')
local Engine_Helper       = require('engine.helper')
local Engine_Components   = require('engine.components')
local Engine_Types        = require('engine.types')

local lg = love.graphics
local lw = love.window

-- Sorts the entities in the given table `t` by their `z` component.
-- FIXME: Not having a Z means not being rendered
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

  local defaultAnchorPoint = Engine_Types.Point:new(0.5, 0.5)
  local anchorPoint = entity:get(Engine_Components.AnchorPoint)
    or defaultAnchorPoint

  lg.translate(-size.width * anchorPoint.x, -size.height * anchorPoint.y)
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
    if scale.y then
      lg.scale(scale.x, scale.y)
    else
      lg.scale(scale.x, scale.x)
    end
  end
end

function Rendering.new(entities)
  -- TODO: Find all image components and cache them here
  return setmetatable({ entities = entities }, Rendering)
end

function Rendering:draw()
  for entity in ipairsSortedByZ(self.entities) do
    self:_drawEntity(entity)
  end
end

function Rendering:_drawEntity(entity)
  local position = entity:get(Engine_Components.Position)
  if not position then return end

  lg.push()

  lg.translate(position.x, position.y)
  rotate(entity)
  scale(entity)

  lg.setColor(255, 255, 255, 255)
  self:_drawEntitySimple(entity)

  lg.pop()
end

-- FIXME: This is duplicated!
local function screenToWorld(screenPoint, viewportSize, viewportPosition, cameraPosition, scale)
  local viewportPoint = Engine.Types.Point:new(
    screenPoint.x - viewportPosition.x + viewportSize.width  / 2,
    screenPoint.y - viewportPosition.y + viewportSize.height / 2
  )

  local unscaledWorldPoint = Engine_Types.Point:new(
    viewportPoint.x - viewportSize.width  / 2,
    viewportPoint.y - viewportSize.height / 2
  )

  local scaledWorldPoint = Engine_Types.Point:new(
    unscaledWorldPoint.x / scale.value + cameraPosition.x,
    unscaledWorldPoint.y / scale.value + cameraPosition.y
  )

  return scaledWorldPoint
end

function Rendering:_drawViewport(viewport)
  local viewportComponent = viewport:get(Engine_Components.Viewport)

  local camera   = viewportComponent.camera
  local entities = viewportComponent.entities

  local viewportPosition = viewport:get(Engine_Components.Position)
  local cameraPosition   = camera:get(Engine_Components.Position)
  local size             = viewport:get(Engine_Components.Size)
  local scale            = camera:get(Engine_Components.Scale)
  local rotation         = camera:get(Engine_Components.Rotation)

  if not size             then error("Viewport lacks size")     end
  if not viewportPosition then error("Viewport lacks position") end
  if not cameraPosition   then error("Camera lacks position")   end

  local rect = Engine_Helper.rectForEntity(viewport)

  lg.push()

  lg.setColor(255, 0, 0, 100)
  lg.rectangle("fill", -size.width/2, -size.height/2, size.width, size.height)

  lg.setStencil(function()
    lg.rectangle("fill", -size.width/2, -size.height/2, size.width, size.height)
  end)

  if scale then
    lg.scale(scale.value, scale.value)
  end

  if rotation then
    lg.rotate(rotation.value)
  end

  lg.translate(- cameraPosition.x, - cameraPosition.y)

  for entity in ipairsSortedByZ(entities) do
    lg.setColor(255, 255, 255, 255)
    self:_drawEntity(entity)
  end

  lg.setStencil()

  lg.pop()
end

function Rendering:_drawEntitySimple(entity)
  local rect = Engine_Helper.rectForEntity(entity)

  local anchorPoint = entity:get(Engine_Components.AnchorPoint)

  local apx = anchorPoint and anchorPoint.x or 0.5
  local apy = anchorPoint and anchorPoint.y or 0.5

  if entity:get(Engine_Components.Viewport) then
    self:_drawViewport(entity)
    return
  end

  local image = entity:get(Engine_Components.Image)
  if image then
    lg.draw(
      Engine_AssetManager.image(image.path),
      - rect.size.width  * apx,
      - rect.size.height * apy
    )
    return
  end

  local particleSystem = entity:get(Engine_Components.ParticleSystem)
  if particleSystem then
    lg.draw(particleSystem.wrapped)
    return
  end

  local animation = entity:get(Engine_Components.Animation)
  if animation then
    local imagePath = animation.imagePaths[animation.curFrame]
    lg.draw(
      Engine_AssetManager.image(imagePath),
      - rect.size.width  * apx,
      - rect.size.height * apy
    )
    return
  end

  local renderer = entity:get(Engine_Components.Renderer)
  if renderer then
    local rendererClass = Engine_Helper.rendererNamed(renderer.name)
    rendererClass.draw(entity)
  end
end

return Rendering
