local Angle = {}

function Angle.normalize(rad)
  if rad < -math.pi then
    return Angle.normalize(rad + 2 * math.pi)
  elseif rad > math.pi then
    return Angle.normalize(rad - 2 * math.pi)
  else
    return rad
  end
end

return Angle
