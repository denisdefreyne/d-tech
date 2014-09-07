local here = (...):match("(.-)[^%.]+$")

local Engine_AssetManager = require(here .. 'asset_manager')
local Engine_Components   = require(here .. 'components')
local Engine_Types        = require(here .. 'types')

local Helper = {}

-- TODO: Move this elsewhere
function Helper.rectForEntity(entity)
  local position = entity:get(Engine_Components.Position)
  if not position then return nil end

  local size = Helper.sizeForEntity(entity)
  if not size then return nil end

  local anchorPoint = entity:get(Engine_Components.AnchorPoint)
  local x = anchorPoint and anchorPoint.x or 0.5
  local y = anchorPoint and anchorPoint.y or 0.5

  return Engine_Types.Rect:new(
    position.x - size.width  * x,
    position.y - size.height * y,
    size.width,
    size.height)
end

-- TODO: Move this elsewhere
function Helper.sizeForEntity(entity)
  local size = entity:get(Engine_Components.Size)
  if size then
    return size
  end

  local imageComponent     = entity:get(Engine_Components.Image)
  local animationComponent = entity:get(Engine_Components.Animation)

  local imagePath
  if imageComponent then
    imagePath = imageComponent.path
  elseif animationComponent then
    imagePath = animationComponent.imagePaths[animationComponent.curFrame]
  end

  local image = imagePath and Engine_AssetManager.image(imagePath)

  if image then
    local w = image:getWidth()
    local h = image:getHeight()

    local scaleComponent = entity:get(Engine_Components.Scale)
    local scale = scaleComponent and scaleComponent.value or 1.0

    return Engine_Types.Size:new(w * scale, h * scale)
  end

  return nil
end

function Helper.screenToWorld(screenPoint, viewport)
  local viewportComponent = viewport:get(Engine_Components.Viewport)

  local camera   = viewportComponent.camera
  local entities = viewportComponent.entities

  local viewportPosition = viewport:get(Engine_Components.Position)
  local cameraPosition   = camera:get(Engine_Components.Position)
  local viewportSize     = viewport:get(Engine_Components.Size)
  local scaleC           = camera:get(Engine_Components.Scale)
  local rotationC        = camera:get(Engine_Components.Rotation)

  local scale    = scaleC and scaleC.value or 1
  local rotation = rotationC and rotationC.value or 1

  local viewportPoint = Engine_Types.Point:new(
    screenPoint.x - viewportPosition.x + viewportSize.width  / 2,
    screenPoint.y - viewportPosition.y + viewportSize.height / 2
  )

  local unscaledWorldPoint = Engine_Types.Point:new(
    viewportPoint.x - viewportSize.width  / 2,
    viewportPoint.y - viewportSize.height / 2
  )

  local scaledWorldPoint = Engine_Types.Point:new(
    unscaledWorldPoint.x / scale + cameraPosition.x,
    unscaledWorldPoint.y / scale + cameraPosition.y
  )

  -- TODO: Take rotation into account

  return scaledWorldPoint
end

function Helper.entityAtPosition(entities, point)
  local fn = function(e)
    local rect = Helper.rectForEntity(e)
    if not rect then return end

    return rect:containsPoint(point)
  end

  return entities:find(fn)
end

-- TODO: Move this elsewhere

local renderers = {}

function Helper.registerRenderer(name, class)
  renderers[name] = class
end

function Helper.rendererNamed(name)
  return renderers[name]
end

return Helper
