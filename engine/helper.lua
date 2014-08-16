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

  return Engine_Types.Rect.new(
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

  local imageComponent = entity:get(Engine_Components.Image)
  local image = imageComponent and Engine_AssetManager.image(imageComponent.path)

  if image then
    local w = image:getWidth()
    local h = image:getHeight()

    local scaleComponent = entity:get(Engine_Components.Scale)
    local scale = scaleComponent and scaleComponent.value or 1.0

    return Engine_Types.Size.new(w * scale, h * scale)
  end

  return nil
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
