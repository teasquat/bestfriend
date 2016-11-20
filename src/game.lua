local game = state:new()

function game.load()
  print("loaded, boi")
end

function game.update(dt)
  print("fucking aye: " .. dt)
end

function game.draw()
  love.graphics.setColor(255, 0, 255)
  love.graphics.circle("fill", 100, 200, 64)
end

function game.unload()
  print("byeeee")
end

return game
