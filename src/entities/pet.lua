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

    health = 100,
  }

  pet.img = love.graphics.newImage(path)

  function pet:load()
    world:add(self,self.x,self.y,self.w,self.h)
  end

  function pet:update(dt)
    self.dy = self.dy + self.g * dt
    self.dy = self.dy - (self.dy / self.frcy) * dt

    self.x, self.y, self.cols = world:move(self, self.x + self.dx, self.y + self.dy)

    if self.health > 0 then
      self.health = self.health - 10 * dt
    end
  end

  function pet:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(self.img, self.x, self.y)

    love.graphics.setColor(255, 0, 0)
    love.graphics.rectangle("fill", self.x - 25, self.y - 30, 50, 10)
    love.graphics.setColor(0, 255, 0)
    love.graphics.rectangle("fill", self.x - 25, self.y - 30, self.health /2, 10)
  end

  return pet
end
return pet_factory
