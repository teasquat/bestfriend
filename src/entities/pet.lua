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

    player = nil,
    picked_up = true,
    -- status
    status = "ignore",
  }

  pet.img = love.graphics.newImage(path)

  function pet:load()
    world:add(self,self.x,self.y,self.w,self.h)
  end

  function pet:update(dt)
    if not self.picked_up then
      self.dy = self.dy + self.g * dt
      self.dy = self.dy - (self.dy / self.frcy) * dt
    end
    self.x, self.y, self.cols = world:move(self, self.x + self.dx, self.y + self.dy, ignore_filter)

    if self.health > 0 then
      self.health = self.health - 10 * dt
    end
  end

  function pet:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(self.img, self.x, self.y)

    love.graphics.setColor(255, 0, 0)
    love.graphics.rectangle("fill", self.x - 20, self.y - 15, 50, 5)
    love.graphics.setColor(0, 255, 0)
    love.graphics.rectangle("fill", self.x - 20, self.y - 15, self.health /2, 5)
  end

  return pet
end
return pet_factory
