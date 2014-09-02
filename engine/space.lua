local Space = {}

function Space.new(entities, systems)
  local t = { entities = entities, systems = systems }
  return setmetatable(t, { __index = Space })
end

function Space:update(dt)
  for _, system in pairs(self.systems) do
    if system.update then system:update(dt) end
  end

  self.entities:prune()
end

function Space:draw()
  for _, system in pairs(self.systems) do
    if system.draw then system:draw() end
  end
end

function Space:mousepressed(x, y, button)
  local res = false
  for _, system in pairs(self.systems) do
    if system.mousepressed then
      res = system:mousepressed(x, y, button) or res
    end
  end
  return res
end

function Space:mousereleased(x, y, button)
  local res = false
  for _, system in pairs(self.systems) do
    if system.mousereleased then
      res = system:mousereleased(x, y, button) or res
    end
  end
  return res
end

function Space:keypressed(key, isrepeat)
  local res = false
  for _, system in pairs(self.systems) do
    if system.keypressed then
      res = system:keypressed(key, isrepeat) or res
    end
  end
  return res
end

function Space:leave()
  for _, system in pairs(self.systems) do
    if system.leave then system:leave() end
  end
end

return Space
