local here = (...):match("(.-)[^%.]+$")

local Panel = require(here .. 'space.panel')

local lg = love.graphics

local Space = {}
Space.__index = Space

function Space.new()
  local prefix = 'debugger/themes/space/assets/fonts/fira/'

  local self = {
    panel = Panel.new(),
    keyFont    = lg.newFont(prefix .. 'FiraSans-Bold.ttf',    16),
    valueFont  = lg.newFont(prefix .. 'FiraSans-Regular.ttf', 16),
    buttonFont = lg.newFont(prefix .. 'FiraSans-Bold.ttf',    16),
  }

  return setmetatable(self, Space)
end

return Space
