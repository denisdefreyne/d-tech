local Panel = {}
Panel.__index = Panel

local lg = love.graphics

function Panel.new()
  local image = lg.newImage('game/assets/UI pack Space/PNG/glassPanel.png')
  image:setWrap('repeat')

  local w = image:getWidth()
  local h = image:getHeight()

  local cornerRadius = 8
  local sliceWidth   = 2

  local quads = {
    m  = lg.newQuad(cornerRadius, cornerRadius, sliceWidth, sliceWidth, w, h),

    tl = lg.newQuad(0,                0,                cornerRadius, cornerRadius, w, h),
    tr = lg.newQuad(w - cornerRadius, 0,                cornerRadius, cornerRadius, w, h),
    bl = lg.newQuad(0,                h - cornerRadius, cornerRadius, cornerRadius, w, h),
    br = lg.newQuad(w - cornerRadius, h - cornerRadius, cornerRadius, cornerRadius, w, h),

    t  = lg.newQuad(cornerRadius,     0,                sliceWidth,   cornerRadius, w, h),
    r  = lg.newQuad(w - cornerRadius, cornerRadius,     cornerRadius, sliceWidth,   w, h),
    b  = lg.newQuad(cornerRadius,     h - cornerRadius, sliceWidth,   cornerRadius, w, h),
    l  = lg.newQuad(0,                cornerRadius,     cornerRadius, sliceWidth,   w, h),
  }

  local t = {
    image = image,
    quads = quads,
  }

  return setmetatable(t, Panel)
end

function Panel:draw(size)
  local cornerRadius = 8
  local sliceWidth   = 2

  local innerHeight = size.height - 2 * cornerRadius
  local innerWidth  = size.width  - 2 * cornerRadius

  local xStretch = innerWidth  / sliceWidth
  local yStretch = innerHeight / sliceWidth

  -- middle
  local x = cornerRadius
  local y = cornerRadius
  local sx = xStretch
  local sy = yStretch
  love.graphics.draw(self.image, self.quads.m, x, y, 0, sx, sy)

  -- top
  local x = cornerRadius
  local y = 0
  local sx = xStretch
  local sy = 1
  love.graphics.draw(self.image, self.quads.t, x, y, 0, sx, sy)

  -- top left
  local x = 0
  local y = 0
  local sx = 1
  local sy = 1
  love.graphics.draw(self.image, self.quads.tl, x, y, 0, sx, sy)

  -- left
  local x = 0
  local y = cornerRadius
  local sx = 1
  local sy = yStretch
  love.graphics.draw(self.image, self.quads.l, x, y, 0, sx, sy)

  -- bottom left
  local x = 0
  local y = cornerRadius + innerHeight
  local sx = 1
  local sy = 1
  love.graphics.draw(self.image, self.quads.bl, x, y, 0, sx, sy)

  -- bottom
  local x = cornerRadius
  local y = cornerRadius + innerHeight
  local sx = xStretch
  local sy = 1
  love.graphics.draw(self.image, self.quads.b, x, y, 0, sx, sy)

  -- bottom right
  local x = cornerRadius + innerWidth
  local y = cornerRadius + innerHeight
  local sx = 1
  local sy = 1
  love.graphics.draw(self.image, self.quads.br, x, y, 0, sx, sy)

  -- right
  local x = cornerRadius + innerWidth
  local y = cornerRadius
  local sx = 1
  local sy = yStretch
  love.graphics.draw(self.image, self.quads.r, x, y, 0, sx, sy)

  -- top right
  local x = cornerRadius + innerWidth
  local y = 0
  local sx = 1
  local sy = 1
  love.graphics.draw(self.image, self.quads.tr, x, y, 0, sx, sy)
end

return Panel
