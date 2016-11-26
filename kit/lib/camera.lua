local camera_factory = {}

function camera_factory.make(x, y, sx, sy, r)
  local camera = {
    x  = x,
    y  = y,
    sx = sx,
    sy = sy,
    r  = r,
  }

  function camera:set()
    love.graphics.push()
    love.graphics.rotate(-self.r)
    love.graphics.scale(1 / self.sx, 1 / self.sy)
    love.graphics.translate(-self.x, -self.y)
  end

  function camera:unset()
    love.graphics.pop()
  end

  function camera:view_width()
    return love.graphics.getWidth() * self.sx
  end

  function camera:view_height()
    return love.graphics.getHeight() * self.sy
  end

  function camera:view_dimensions()
    return self:view_width(), self:view_height()
  end

  return camera
end

return camera_factory
