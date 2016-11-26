local game = state:new()

-- handlers
game_objects = {} -- all local game objects
online_refs  = {} -- all references to to-be-submitted objects

function game.load()
  game_objects = {}

  -- TODO: make level stuff
  local player_factory = require("src/entities/player")
  table.insert(game_objects, player_factory.make(100, 100))

  local block_factory  = require("src/entities/player")
  table.insert(game_objects, block_factory.make(100, 400, love.graphics.getWidth(), 64))
end

function game.update(dt)
  for i, v in ipairs(game_objects) do
    if v.update then
      v:update(dt)
    end
  end
end

function game.draw()
  for i, v in ipairs(game_objects) do
    if v.update then
      v:draw()
    end
  end
end

function game.unload()

end

return game
