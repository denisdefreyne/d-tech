require('engine.vendor.slam.slam')

local AssetManager = {}

local imageCache = {}
local soundCache = {}

function AssetManager.get(cache, fn, path, ...)
  if not cache[path] then
    cache[path] = fn(path, ...)
  end

  return cache[path]
end

function AssetManager.image(path)
  return AssetManager.get(imageCache, love.graphics.newImage, path)
end

function AssetManager.sound(path)
  return AssetManager.get(soundCache, love.audio.newSource, path, "static")
end

return AssetManager
