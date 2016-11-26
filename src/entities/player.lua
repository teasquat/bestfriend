local player_factory = {}

function player_factory.make(x, y)
  local player = {
      x = x, y = y,
      -- velocity
      dx = 0,
      dy = 0,
      -- movement
      acc  = 30,   -- acceleration
      frcx = 0.1,  -- friction x
      frcy = 1.5,  -- friction y
      -- (kinda-lol) static
      w = 16,     -- width
      h = 16,     -- height

      right = "right",
      left  = "left",
      jump  = "x",
      pew   = "c",
      -- jumping
      grounded   = false,  -- whether or not am touching ground
      jump_force = 7,      -- how much force to apply when normal jumping
      -- wall jumping
      wall_force = 6,      -- how much force to apply when wall jumping
      wall       = 0,
      -- static
      gravity    = 30,
      -- pet stuff
      pet = nil,
      picked_up = true,
      -- status
      status = "ignore",
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

    self.dx = self.dx - self.wall * dt

    self.dy = self.dy + self.gravity * dt

    -- friction
    self.dx = self.dx - (self.dx / self.frcx) * dt
    self.dy = self.dy - (self.dy / self.frcy) * dt

    -- movement
    self.x, self.y, self.cols = world:move(self, self.x + self.dx, self.y + self.dy, ignore_filter)

    self.grounded = false

    local ww, wh = camera:view_dimensions()
    camera.x = math.lerp(camera.x, self.x + self.w / 2 - ww / 2, dt * 3) -- interpolate camera towards player
    camera.y = math.lerp(camera.y, self.y + self.h / 2 - wh / 1.45, dt * 2.5) -- interpolate camera towards player

    self.wall = 0
    for i, v in ipairs(self.cols) do
      if v.normal.y ~= 0 then
        if v.normal.y == -1 then

          local shake   = self.dy * 2
          local epsilon = 2
          if shake < epsilon then
            shake = 0
          elseif -shake > -epsilon then
            shake = 0
          end

          --shack:set_shake(shake)

          self.grounded = true
        end
        if v.other ~= self.pet then
          self.dy = 0
        end
      end

      if v.normal.x ~= 0 then
        self.dx = 0

        if not self.grounded then
          self.wall = v.normal.x
        end
      end
    end

    if self.picked_up then
      self.pet.y = self.y - self.h
      self.pet.x = self.x
    end
  end

  function player:draw()
    -- TODO: make good graphics
    love.graphics.setColor(255, 0, 0)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
  end

  function player:throw()
    if self.picked_up then
      self.picked_up     = false
      self.pet.picked_up = false

      local throw_x, throw_y = self.dx, self.dy

      if throw_x + throw_y < 0.5 and throw_x + throw_y > -0.5 then
        if throw_y < 0.005 and throw_y > -0.005 then
          throw_y = throw_y - 1.5
        end

        if throw_x < 0.5 and throw_x > -0.5 then
          throw_x = throw_x * 10
        end

        if throw_y < 0.5 and throw_y > -0.5 then
          throw_y = throw_y * 10
        end
      end

      self.pet.dx = throw_x * 5
      self.pet.dy = throw_y * 5
    end
  end

  function player:pick_up()
    for i, v in ipairs(self.cols) do
      if v.other == self.pet then
        self.picked_up     = true
        self.pet.picked_up = true
      end
    end
  end

  function player:press(key, isrepeat)
    if key == self.jump then
      if self.grounded then
        self.dy = -self.jump_force
      elseif self.wall ~= 0 then
        self.dy = -self.wall_force
        self.dx = self.wall_force / 1.5 * self.wall
      end
    elseif key == self.pew then
      if self.picked_up then
        self:throw()
      else
        self:pick_up()
      end
    end
  end

  return player
end

return player_factory
