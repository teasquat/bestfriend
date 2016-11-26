local game = state:new()

love.graphics.setBackgroundColor(255, 255, 255)

function math.lerp(a, b, t)
  return (1 - t) * a + t * b
end

-- handlers
game_objects = {} -- all local game objects
online_refs  = {} -- all references to to-be-submitted objects

function game.load()
  game_objects = {}

  -- TODO: make level stuff
  local player_factory = require("src/entities/player")
  table.insert(game_objects, player_factory.make(100, 100))

  local block_factory  = require("src/entities/block")
  table.insert(game_objects, block_factory.make(100, 400, love.graphics.getWidth(), 64))

  for i, v in ipairs(game_objects) do
    v:load()
  end
end

function game.update(dt)
  for i, v in ipairs(game_objects) do
    if v.update then
      v:update(dt)
    end
  end
end

function game.draw()
  love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
  for i, v in ipairs(game_objects) do
    if v.draw then
      v:draw()
    end
  end
end

function love.keypressed(key, isrepeat)
  for i, v in ipairs(game_objects) do
    if v.press then
      v:press(key, isrepeat)
    end
  end
end

function love.keyreleased(key, isrepeat)
  for i, v in ipairs(game_objects) do
    if v.release then
      v:release(key, isrepeat)
    end
  end
end

function game.unload()

end

return game
