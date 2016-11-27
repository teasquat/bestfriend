local player_net_factory = {}

function player_net_factory.make(x, y, dx, dy)
  local player = {
      x = x, y = y,
      -- velocity
      dx = dx,
      dy = dy,
      -- movement
      acc  = 30,   -- acceleration
      frcx = 0.1,  -- friction x
      frcy = 1.5,  -- friction y
      -- (kinda-lol) static
      w = 16,     -- width
      h = 16,     -- height

      -- static
      gravity    = 30,
      -- pet stuff
      picked_up = true,
      -- status
      status = "ignore",
      -- animation
      walk      = {love.graphics.newImage("assets/player/walk1.png"), love.graphics.newImage("assets/player/walk2.png")},
      walk_n    = {love.graphics.newImage("assets/player/walk_n1.png"), love.graphics.newImage("assets/player/walk_n2.png")},
      neutral   = {love.graphics.newImage("assets/player/neutral.png")},
      neutral_n = {love.graphics.newImage("assets/player/neutral_n.png")},

      index   = 1,
      dir     = 1,
  }

  function player:load()
    world:add(self, self.x, self.y, self.w, self.h)

    self.current = self.walk
  end

  function player:update(dt)
    self.index = self.index + dt * 2 * self.dx
    self.dir = math.sign(self.dx) or self.dir

    local still = self.dx < 0.005 and self.dx > -0.005

    if self.picked_up then
      if still then
        self.current = self.neutral_n
      else
        self.current = self.walk
      end
    else
      if still then
        self.current = self.neutral
      else
        self.current = self.walk_n
      end
    end

    self.dy = self.dy + self.gravity * dt

    -- friction
    self.dx = self.dx - (self.dx / self.frcx) * dt
    self.dy = self.dy - (self.dy / self.frcy) * dt

    -- movement
    self.x, self.y, self.cols = world:move(self, self.x + self.dx, self.y + self.dy, ignore_filter)

    self.grounded = false

    self.wall = 0
    for i, v in ipairs(self.cols) do
      if v.normal.y ~= 0 then
        if v.normal.y == -1 then
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
  end

  function player:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(self.current[math.floor(self.index % #self.current) + 1], self.x + self.w / 2, self.y, 0, self.dir, 1, self.w / 2)
  end

  function player:move(x, y, dx, dy)
    self.x, self.y, self.dx, self.dy = x, y, dx, dy
  end

  return player
end

return player_net_factory
