local Engine = require('engine')
local Debugger_Components = require('debugger.components')
local Theme = require('debugger.themes.space')

local Inspector = {}

local lg = love.graphics
local lw = love.window

local function getDetails(entity)
  local t = {}

  -- extra
  for componentType, component in pairs(entity) do
    local key   = componentType.name
    local value = componentType.format(component)

    table.insert(t, { key = key, value = value, type = componentType })
  end

  table.sort(t, function(a, b) return a.type.order < b.type.order end)

  return t
end

function Inspector.draw(entity)
  local theme = Theme.new()
  local panel = theme.panel

  local size = entity:get(Engine.Components.Size)

  lg.setColor(0, 0, 0, 200)
  Engine.Types.Rect.new(0, 0, size.width, size.height):fill()
  lg.setColor(255, 255, 255, 255)

  panel:draw(size)

  local selectionTracker = entity:get(Debugger_Components.SelectionTracker)
  local selectedEntity = selectionTracker and selectionTracker.selectedEntity

  if not selectedEntity then
    lg.setFont(theme.keyFont)
    lg.print('(nothing selected)', 20, 20)
  else
    local entity = selectedEntity
    local details = getDetails(entity)

    local groupSpacing = 10
    local lineHeight   = 20

    for i = 1, #details do
      local detail = details[i]
      local x = 20
      local y = 20 + (i - 1) * groupSpacing + 2 * (i - 1) * lineHeight

      lg.setFont(theme.keyFont)
      lg.print(detail.key, x, y)

      lg.setFont(theme.valueFont)
      lg.print(detail.value, x, y + lineHeight)
    end
  end
end

return Inspector
