local player_factory = {}

function player_factory.make(x, y)
  local player = {
      x = x, y = y,
      -- velocity
      dx = 0,
      dy = 0,
      -- movement
      acc  = 30,   -- acceleration
      frcx = 0.15,  -- friction x
      frcy = 1.5,  -- friction y
      -- (kinda) static
      w = 16,     -- width
      h = 16,     -- height

      right = "right",
      left  = "left",
      jump  = "x",
      -- jumping
      grounded   = false,  -- whether or not am touching ground
      jump_force = 10,     -- how much force
      --static
      gravity    = 30,
  }

  function player:load()
    world:add(self, self.x, self.y, self.w, self.h)
  end

  function player:update(dt)
    if love.keyboard.isDown(self.right) then
      self.dx = self.dx + self.acc * dt
    end

    if love.keyboard.isDown(self.left) then
      self.dx = self.dx - self.acc * dt
    end

    self.dy = self.dy + self.gravity * dt

    -- friction
    self.dx = self.dx - (self.dx / self.frcx) * dt
    self.dy = self.dy - (self.dy / self.frcy) * dt

    -- movement
    self.x, self.y, self.cols = world:move(self, self.x + self.dx, self.y + self.dy)

    self.grounded = false

    local ww, wh = camera:view_dimensions()
    camera.x = math.lerp(camera.x, self.x - ww / 2, dt * 3) -- interpolate camera towards player

    for i, v in ipairs(self.cols) do
      if v.normal.y ~= 0 then
        if v.normal.y == -1 then

          shack:set_shake(self.dy * 4)

          self.grounded = true
          self.dy       = 0
        end
      end

      if v.normal.x ~= 0 then
        self.dx = 0
      end
    end
  end

  function player:draw()
    -- TODO: make good graphics
    love.graphics.setColor(255, 0, 0)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
  end

  function player:press(key, isrepeat)
    if key == self.jump then
      if self.grounded then
        self.dy = -self.jump_force
      end
    end
  end

  return player
end

return player_factory
