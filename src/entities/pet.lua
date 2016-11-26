local pet_factory = {}

function pet_factory.make(x, y, path)
  local pet = {
    x = x, y = y,
    w = 16, h = 16,
    -- velocity
    dx = 0,  -- deltaX
    dy = 0,  -- deltaY
    -- movement
    acc  = 30,   -- acceleration
    frcx = 0.15,  -- friction x
    frcy = 1.5,  -- friction y
    -- static
    g = 30, -- gravity
    -- movement
    frcx = 1.5,  -- friction x
    frcy = 1.5,  -- friction y
    --
    health = 100,

    picked_up = true,
    -- status
    status = "ignore",
  }

  function pet.filter(item, other)
    if other.status == "ignore" then
      return
    end
    return "slide"
  end

  pet.img = love.graphics.newImage("assets/pet/" .. path .. ".png")

  function pet:load()
    world:add(self,self.x,self.y,self.w,self.h)
  end

  function pet:update(dt)
    if not self.picked_up then
      self.dy = self.dy + self.g * dt
      self.dy = self.dy - (self.dy / self.frcy) * dt

      -- friction
      self.dx = self.dx - (self.dx / self.frcx) * dt
      self.dy = self.dy - (self.dy / self.frcy) * dt

      self.x, self.y, self.cols = world:move(self, self.x + self.dx, self.y + self.dy, self.filter)

      for i, v in ipairs(self.cols) do
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

    if self.health > 0 then
      self.health = self.health - 10 * dt
    end
  end

  function pet:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(self.img, self.x, self.y)

    love.graphics.setColor(255, 0, 0)
    love.graphics.rectangle("fill", self.x + self.w / 2 - 20, self.y - self.h / 2.25, 40, 4)
    love.graphics.setColor(0, 255, 0)
    love.graphics.rectangle("fill", self.x + self.w / 2 - 20, self.y - self.h / 2.25, (self.health / 100) * 40, 4)
  end

  return pet
end
return pet_factory
