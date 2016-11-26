local block_factory = {}

function block_factory.make(x, y, w, h, path)
  local block = {
    x = x, y = y,
    w = w, h = h,
  }

  block.img = love.graphics.newImage(path)

  function block:load()
    world:add(self, self.x, self.y, self.w, self.h)
  end

  function block:draw()
    -- TODO: make beautiful
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(self.img, self.x, self.y)
  end

  return block
end

return block_factory
