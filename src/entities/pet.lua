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
    g = 30 -- gravity

  }
  function pet:load()
    world:add(self,self.x,self.y,self.w,self.h)
  end
  function pet:update(dt)
    self.dy = self.dy + self.g * dt
    self.dy = self.dy - (self.dy / self.frcy) * dt

    self.x, self.y, self.cols = world:move(self, self.x + self.dx, self.y + self.dy)

  end
  function pet:draw()
    love.graphics.setColor(130, 90, 30)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.w)
  end
  return pet
end
return pet_factory
