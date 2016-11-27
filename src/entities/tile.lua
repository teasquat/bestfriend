local block_factory = {}

function block_factory.make(x, y, path)
  local block = {
    x = x, y = y,
    w = w, h = h,
  }

  block.img = love.graphics.newImage(path)

  function block:draw()
    -- TODO: make beautiful
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(self.img, self.x, self.y)
  end

  return block
end

return block_factory
