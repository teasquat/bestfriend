local block_factory = {}

function block_factory.make(x, y, w, h)
  local block = {}

  function block:load()
    world:add(self, self.x, self.y, self.w, self.h)
  end

  function block:draw()
    -- TODO: make beautiful
    love.graphics.setColor(0, 255, 0)
    love.graphics.rectangle(self.x, self.y, self.w, self.h)
  end

  return block
end

return block_factory
