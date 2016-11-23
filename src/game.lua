local game = state:new()

local light = light_world:newLight(100, 200, 255, 255, 255, 1300)
local circl = light_world:newRectangle(100, 100, 100, 100)

function game.load()

end

function game.update(dt)
  circl:setPosition(love.mouse.getX(), love.mouse.getY())
end

function game.draw()
  love.graphics.setColor(255, 255, 255)
  love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

  love.graphics.setColor(255, 0, 255)
  love.graphics.polygon("fill", circl:getPoints())
end

function game.unload()
  print("byeeee")
end

return game
