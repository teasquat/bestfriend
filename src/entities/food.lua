local food_factory = {}

function food_factory.make(x,y)
  local food = {
    x = x, y = y,
    w = 8, h = 8,
  }

  function food:load ()
    world:add(self,self.x,self.y,self.w,self.h)
  end
  function food:update (dt)
  end
  function food:draw()
    love.graphics.setColor(255, 255, 0)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
  end

  return food
end

return food_factory
