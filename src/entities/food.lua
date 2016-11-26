local food_factory = {}

function food_factory.make(x,y)
  local food = {
    x = x, y = y,
    w = 8, h = 8,
    dx = 0, dy = 0,
    acc = 30,
    g = 30,
    frcx = 1.5, frcy = 1.5,
    status = "food"
  }

  function food:load ()
    world:add(self,self.x,self.y,self.w,self.h)
  end
  function food:update (dt)
    self.dy = self.dy + self.g * dt
    self.dy = self.dy - (self.dy / self.frcy) * dt
    self.dx = self.dx - (self.dx / self.frcx) * dt

    self.x, self.y, self.cols = world:move(self, self.x + self.dx, self.y + self.dy)
  end
  function food:draw()
    love.graphics.setColor(255, 255, 0)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
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
