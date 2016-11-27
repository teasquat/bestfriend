local pet_factory = {}

function pet_factory.make(x, y, dx, dy, path)
  local pet = {
    x = x, y = y,
    w = 16, h = 16,
    -- velocity
    dx = dx,  -- deltaX
    dy = dy,  -- deltaY
    -- movement
    acc  = 30,   -- acceleration
    -- static
    g = 30, -- gravity
    -- movement
    frcx = 1.5,  -- friction x
    frcy = 1.5,  -- friction y

    picked_up = false,
    -- status
    status = "ignore",
    dir = 1,
    -- animation
    blink = {},
    index = 1,
  }

  function pet.filter(item, other)
    if other.status == "ignore" then
      return
    end
    return "slide"
  end

  function pet:load()
    world:add(self,self.x,self.y,self.w,self.h)

    path = "turtle"
    self.blink[1] = love.graphics.newImage("assets/pet/" .. path .. ".png")
    self.blink[2] = love.graphics.newImage("assets/pet/" .. path .. "_.png")
  end

  function pet:update(dt)
    if math.floor(self.index % #self.blink) + 1 == 1 then
      self.index = self.index + dt / 2
    else
      self.index = self.index + dt * 3
    end

    if not self.picked_up then
      self.dy = self.dy + self.g * dt

      -- friction
      self.dx = self.dx - (self.dx / self.frcx) * dt
      self.dy = self.dy - (self.dy / self.frcy) * dt

      self.x, self.y, self.cols = world:move(self, self.x + self.dx, self.y + self.dy, self.filter)

      for i, v in ipairs(self.cols) do
        if v.other.status == "food" then
          self.health = self.health + 50
          v.other:die()
        end
        if v.normal.y ~= 0 then
          self.dy = 0
        end

        if v.normal.x ~= 0 then
          self.dx = 0
        end
      end
    else
      world:update(self, self.x, self.y)
    end
  end

  function pet:draw()
    if self.rainbow_stuff then
      love.graphics.setColor(math.random(0, 255), math.random(0, 255), math.random(0, 255))
    else
      love.graphics.setColor(255, 255, 255)
    end
    love.graphics.draw(self.blink[math.floor(self.index % #self.blink) + 1], self.x + self.w / 2, self.y, 0, self.dir, 1, self.w / 2)
  end

  function pet:move(x, y, dx, dy)
    self.x, self.y, self.dx, self.dy = x, y, dx, dy
  end

  return pet
end
return pet_factory
