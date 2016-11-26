local player_factory = {}

function player_factory.make(x, y)
  local player = {
      x = x, y = y,
      -- velocity
      dx = 0,
      dy = 0,
      -- movement
      acc  = 30,   -- acceleration
      frcx = 0.5,  -- friction x
      frcy = 1.5,  -- friction y
      -- (kinda) static
      w = 16,     -- width
      h = 16,     -- height

      right = "right",
      left  = "left",
      jump  = "x",
      -- jumping
      grounded   = false,  -- whether or not am touching ground
      jump_force = 20,     -- how much force
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


    -- friction
    self.dx = self.dx - (self.dx / self.frcx) * dt
    self.dy = self.dy - (self.dy / self.frcy) * dt

    -- movement
    self.x, self.y, self.cols = world:move(self, self.x + self.dx, self.y + self.dy)

    for i, v in ipairs(self.cols) do
      if v.normal.y ~= 0 then
        if v.normal.y == -1 then
          self.grounded = true
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

  return player
end

return player_factory
