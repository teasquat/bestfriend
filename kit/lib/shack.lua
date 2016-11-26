local shack = {
  shaking       = 0,
  shakingTarget = 0,

  rotation       = 0,
  rotationTarget = 0,

  scale       = { x = 1, y = 1 },
  scaleTarget = { x = 1, y = 1 },

  shear       = { x = 0, y = 0 },
  shearTarget = { x = 0, y = 0 },

  width  = love.graphics.getWidth(),
  height = love.graphics.getHeight(),
}

setmetatable(shack, shack)

local function lerp(a, b, k)
  if a == b then
    return a
  else
    if math.abs(a-b) < 0.005 then return b else return a * (1-k) + b * k end
  end
end

function shack:set_dimensions(width, height)
  self.width, self.height = width, height
  return self
end

function shack:update(dt)

  local _speed = 7

  self.shaking  = lerp(self.shaking, self.shakingTarget, _speed*dt)
  self.rotation = lerp(self.rotation, self.rotationTarget, _speed*dt)

  self.scale.x  = lerp(self.scale.x, self.scaleTarget.x, _speed*dt)
  self.scale.y  = lerp(self.scale.y, self.scaleTarget.y, _speed*dt)

  self.shear.x  = lerp(self.shear.x, self.shearTarget.x, _speed*dt)
  self.shear.y  = lerp(self.shear.y, self.shearTarget.y, _speed*dt)
end

function shack:apply()
  love.graphics.translate(self.width*.5, self.height*.5)
  love.graphics.rotate((math.random()-.5)*self.rotation)
  love.graphics.scale(self.scale.x, self.scale.y)
  love.graphics.translate(-self.width*.5, -self.height*.5)

  love.graphics.translate((math.random()-.5)*self.shaking, (math.random()-.5)*self.shaking)

  love.graphics.shear(self.shear.x*.01, self.shear.y*.01)

  return self
end

function shack:set_shake(shaking)
  self.shaking = shaking or 0
  return self
end

function shack:set_rotation(rotation)
  self.rotation = rotation or 0
  return self
end

function shack:set_shear(x, y)
  self.shear = { x = x or 0, y = y or 0 }
  return self
end

function shack:set_scale(x, y)
  if not y then
    local _s = x or 1
    self.scale = { x = _s, y = _s }
  else
    self.scale = { x = x or 1, y = y or 1 }
  end
  return self
end

function shack:set_shake_target(shaking)
  self.shakingTarget = shaking or 0
  return self
end

function shack:set_rotation_target(rotation)
  self.rotationTarget = rotation or 0
  return self
end

function shack:set_scale_target(x, y)
  if not y then
    local _s = x or 1
    self.scaleTarget = { x = _s, y = _s }
  else
    self.scaleTarget = { x = x or 1, y = y or 1 }
  end
  return self
end

function shack:set_shear_target(x, y)
  self.shearTarget = { x = x or 0, y = y or 0 }
  return self
end

function shack:get_shake() return self.shaking end
function shack:get_shake_target() return self.shakingTarget end

function shack:get_rotation() return self.rotation end
function shack:get_rotation_target() return self.rotationTarget end

function shack:get_scale() return self.scale.x, self.scale.y end
function shack:get_scale_target() return self.scaleTarget.x, self.scaleTarget.y end

function shack:get_shear() return self.shear.x, self.shear.y end
function shack:get_shear_target() return self.shearTarget.x, self.shearTarget.y end

function shack:shake(...)  return self:set_shake(...) end
function shack:rotate(...) return self:set_rotation(...) end
function shack:zoom(...)   return self:set_scale(...) end
function shack:tilt(...)   return self:set_shear(...) end

return shack
