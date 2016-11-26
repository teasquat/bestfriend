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
  make_level(love.graphics.newImage("assets/levels/demo.png"):getData())

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

-- misc functions
function make_level(image_data)
  for x = 1, image_data:getWidth() do
    for y = 1, image_data:getHeight() do
      local r, g, b, a = image_data:getPixel(x - 1, y - 1)

      if r + g + b == 0 then
        make_block(x * 16, y * 16, "assets/sheets/grass.png", 16, 16)
      elseif r == 255 and g == 0 and b == 0 then
        make_player(x * 16, y * 16)
      end
    end
  end
end

function make_player(x, y)
  local player_factory = require("src/entities/player")
  local player         = player_factory.make(x, y)

  table.insert(game_objects, player)
end

function make_block(x, y, path, w, h) -- path is image
  local block_factory = require("src/entities/block")
  local block         = block_factory.make(x, y, w or 16, h or 16)

  table.insert(game_objects, block)
end

return game
