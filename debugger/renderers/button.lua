local Engine = require('engine')

local Debugger_Components = require('debugger.components')

local Button = {}

local lg = love.graphics

Button.font = lg.newFont(16)

function Button.draw(entity)
  local size  = entity:get(Engine.Components.Size)
  if not size then return end

  local label = entity:get(Debugger_Components.Label)
  if not label then return end

  local cursorTracking = entity:get(Debugger_Components.CursorTracking)

  -- Draw background
  if cursorTracking and cursorTracking.clicked then
    lg.setColor(255, 255, 255, 200)
  elseif cursorTracking and cursorTracking.hovering then
    lg.setColor(255, 255, 255, 150)
  else
    lg.setColor(255, 255, 255, 100)
  end
  lg.rectangle('fill', 0, 0, size.width, size.height)

  lg.setColor(255, 255, 255, 200)
  lg.rectangle('line', 0, 0, size.width, size.height)

  -- Draw text
  local font = Button.font
  local y = size.height / 2 - font:getHeight() / 2
  lg.setFont(font)
  lg.setColor(255, 255, 255, 255)
  lg.printf(label.string, 0, y, size.width, 'center')
end

return Button
