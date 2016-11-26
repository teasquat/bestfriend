local pet_factory = {}

function pet_factory.make(x,y)
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

    health = 100

  }
  function pet:load()
    world:add(self,self.x,self.y,self.w,self.h)
  end
  function pet:update(dt)
    self.dy = self.dy + self.g * dt
    self.dy = self.dy - (self.dy / self.frcy) * dt

    self.x, self.y, self.cols = world:move(self, self.x + self.dx, self.y + self.dy)

    self.health = self.health - 10 * dt

  end
  function pet:draw()
    love.graphics.setColor(130, 90, 30)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.w)
    love.graphics.setColor(255, 0, 0)
    love.graphics.rectangle("fill", self.x - 25, self.y - 30, 50, 10)
    love.graphics.setColor(0, 255, 0)
    love.graphics.rectangle("fill", self.x - 25, self.y - 30, self.health /2, 10)
    end
  return pet
end
return pet_factory
