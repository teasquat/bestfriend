local food_factory = {}

function food_factory.make(x,y)
  local food = {
    x = x, y = y,
    dx = 0, dy = 0,
    acc = 30,
    g = 30,
    frcx = 1.5, frcy = 1.5,
    status = "food",
    -- animation
    fire  = {},
    index = 1,
  }

  function food:load ()

    self.fire[1] = love.graphics.newImage("assets/food/cake1.png")
    self.fire[2] = love.graphics.newImage("assets/food/cake2.png")
    self.fire[3] = love.graphics.newImage("assets/food/cake3.png")

    self.w = self.fire[1]:getWidth()
    self.h = self.fire[1]:getHeight()

    world:add(self, self.x, self.y, self.w, self.h)
  end

  function food:update (dt)
    self.index = self.index + dt * 5

    self.dy = self.dy + self.g * dt
    self.dy = self.dy - (self.dy / self.frcy) * dt
    self.dx = self.dx - (self.dx / self.frcx) * dt

    self.x, self.y, self.cols = world:move(self, self.x + self.dx, self.y + self.dy)
  end

  function food:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(self.fire[math.floor(self.index % #self.fire) + 1], self.x + self.w / 2, self.y, 0, 1, 1, self.w / 2)
  end

  function food:die()
    for i, v in ipairs(game_objects) do
      if v == self then
        table.remove(game_objects, i)
      end
    end
    world:remove(self)
  end

  return food
end

return food_factory
