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

local function anchorPointForEntity(entity)
  local anchorPoint = entity:get(Engine_Components.AnchorPoint)
  local apx = anchorPoint and anchorPoint.x or 0.5
  local apy = anchorPoint and anchorPoint.y or 0.5
  return apx, apy
end

local function translateForAnchorPoint(entity)
  local apx, apy = anchorPointForEntity(entity)
  local size = Engine_Helper.sizeForEntity(entity, false)
  if apx and size then
    lg.translate(-size.width * apx, -size.height * apy)
  end
end

function Rendering.new(entities)
  -- TODO: Find all image components and cache them here
  return setmetatable({ entities = entities }, Rendering)
end

function Rendering:_drawEntities(entities)
  local camera = entities:firstWithComponent(Engine_Components.Camera)

  lg.push()

  if camera then
    local cameraPosition = camera:get(Engine_Components.Position)
    local cameraScale    = camera:get(Engine_Components.Scale)
    local cameraRotation = camera:get(Engine_Components.Rotation)
    local cameraSize     = camera:get(Engine_Components.Size)

    if not cameraPosition or not cameraSize then
      error("Cameras require position and size")
    end

    local dx = - cameraPosition.x + cameraSize.width  / 2
    local dy = - cameraPosition.y + cameraSize.height / 2

    if cameraScale then lg.scale(cameraScale.x, cameraScale.y) end
    if cameraRotation then lg.rotate(cameraRotation.value) end
    lg.translate(dx, dy)
  end

  for entity in ipairsSortedByZ(self.entities) do
    self:_prepareEntity(entity)
    self:_drawEntity(entity)
  end

  lg.pop()
end

function Rendering:draw()
  self:_drawEntities(self.entities)
end

function Rendering:_prepareEntity(entity)
  local imageQuadComponent = entity:get(Engine_Components.ImageQuad)
  if imageQuadComponent and not imageQuadComponent.quad then
    local image = Engine_AssetManager.image(imageQuadComponent.path)
    imageQuadComponent.quad = love.graphics.newQuad(
      imageQuadComponent.x,      imageQuadComponent.y,
      imageQuadComponent.width,  imageQuadComponent.height,
      image:getWidth(), image:getHeight()
    )
  end
end

function Rendering:_drawEntity(entity)
  local position = entity:get(Engine_Components.Position)
  if not position then return end

  lg.push()

  lg.translate(position.x, position.y)
  rotate(entity)
  scale(entity)
  translateForAnchorPoint(entity)

  lg.setColor(255, 255, 255, 255)
  self:_drawEntitySimple(entity)

  lg.pop()
end

function Rendering:_drawViewport(viewport, viewportComponent)
  local camera   = viewportComponent.camera
  local entities = viewportComponent.entities

  local viewportPosition = viewport:get(Engine_Components.Position)
  local size             = viewport:get(Engine_Components.Size)

  if not size             then error("Viewport lacks size")     end
  if not viewportPosition then error("Viewport lacks position") end

  local rect = Engine_Helper.rectForEntity(viewport)

  lg.push()

  lg.setColor(255, 0, 0, 100)
  lg.rectangle("fill", -size.width/2, -size.height/2, size.width, size.height)

  lg.setStencil(function()
    lg.rectangle("fill", -size.width/2, -size.height/2, size.width, size.height)
  end)

  lg.setColor(255, 255, 255, 255)
  Rendering:_drawEntities(entities)

  lg.setStencil()

  lg.pop()
end

function Rendering:_drawImage(entity, imageC)
  local image = Engine_AssetManager.image(imageC.path)
  lg.draw(image)
end

function Rendering:_drawImageQuad(entity, imageQuadC)
  local image = Engine_AssetManager.image(imageQuadC.path)
  lg.draw(image, imageQuadC.quad)
end

function Rendering:_drawParticleSystem(entity, particleSystemC)
  lg.draw(particleSystemC.wrapped)
end

function Rendering:_drawAnimation(entity, animationC)
  local imagePath = animationC.imagePaths[animationC.curFrame]
  local image = Engine_AssetManager.image(imagePath)
  lg.draw(image)
end

function Rendering:_drawCustom(entity, rendererC)
  local rendererClass = Engine_Helper.rendererNamed(rendererC.name)
  rendererClass.draw(entity)
end

function Rendering:_drawEntitySimple(entity)
  local rendererC = entity:get(Engine_Components.Renderer)
  if rendererC then
    self:_drawCustom(entity, rendererC)
    return
  end

  local viewportC = entity:get(Engine_Components.Viewport)
  if viewportC then
    self:_drawViewport(entity, viewportC)
    return
  end

  local imageC = entity:get(Engine_Components.Image)
  if imageC then
    self:_drawImage(entity, imageC)
    return
  end

  local imageQuadC = entity:get(Engine_Components.ImageQuad)
  if imageQuadC then
    self:_drawImageQuad(entity, imageQuadC)
    return
  end

  local particleSystemC = entity:get(Engine_Components.ParticleSystem)
  if particleSystemC then
    self:_drawParticleSystem(entity, particleSystemC)
    return
  end

  local animationC = entity:get(Engine_Components.Animation)
  if animationC then
    self:_drawAnimation(entity, animationC)
    return
  end
end

return Rendering
