local Gamestate = {}

function Gamestate.new(spaces)
  local t = {
    spaces = spaces
  }

  return setmetatable(t, { __index = Gamestate })
end

function Gamestate:update(dt)
  for _, space in ipairs(self.spaces) do
    if space.update then space:update(dt) end
  end
end

function Gamestate:draw()
  -- Draw last space first
  for i = #self.spaces, 1, -1 do
    local space = self.spaces[i]
    if space.draw then space:draw() end
  end
end

function Gamestate:mousepressed(x, y, button)
  for _, space in ipairs(self.spaces) do
    if space.mousepressed then
      local res = space:mousepressed(x, y, button)
      if res then return end
    end
  end
end

function Gamestate:mousereleased(x, y, button)
  for _, space in ipairs(self.spaces) do
    if space.mousereleased then
      local res = space:mousereleased(x, y, button)
      if res then return end
    end
  end
end

function Gamestate:keypressed(key, isrepeat)
  for _, space in ipairs(self.spaces) do
    if space.keypressed then
      local res = space:keypressed(key, isrepeat)
      if res then return end
    end
  end
end

function Gamestate:leave()
  for _, space in pairs(self.spaces) do
    if space.leave then space:leave() end
  end
end

return Gamestate
