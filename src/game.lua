local game = state:new()

love.graphics.setBackgroundColor(130, 220, 250)

function math.lerp(a, b, t)
  return (1 - t) * a + t * b
end

function math.clamp(a, b, x)
  if x < a then
    return b
  elseif x > b then
    return b
  end

  return x
end

function math.sign(n)
  if n < 0 then
    return -1
  elseif n > 0 then
    return 1
  end
  return nil
end

function ignore_filter(item, other)
  if other.status == "ignore" then
    return "cross"
  end
  return "slide"
end

-- handlers
game_objects = {} -- all local game objects
online_refs  = {} -- all references to to-be-submitted objects
pets = {
  [1] = "cat1",
  [2] = "cat2",
  [3] = "cat3",
  [4] = "cat4",
  [5] = "deer",
  [6] = "fish",
  [7] = "parrot",
  [8] = "penguin",
  [9] = "pig",
  [10] = "dog",
  [11] = "turtle",
  [12] = "duck",
  [13] = "bear",
  [14] = "tiger",
  [15] = "elephant",
}

online = true

if online then
  player_net_factory = require("src/entities/player_net")
  pet_net_factory = require("src/entities/pet_net")
  local socket = require "socket"
  client = socket.tcp()
  client:connect("localhost", 7788) -- change to server ip
  client:settimeout(0)
  math.randomseed(os.time())
  player_id = math.random(0,1000000)

  client:send("id_" .. player_id .. "\n")

  pet_net = {}
  player_net = {}
end
t = 0
update_time = 0.5

function game.load()
  math.randomseed(os.time())

  game_objects = {}

  camera.sx, camera.sy = 0.35, 0.35

  -- TODO: make level stuff
  make_level(love.graphics.newImage("assets/levels/demo.png"):getData())

  for i, v in ipairs(game_objects) do
    if v.load then
      v:load()
    end
  end

  --client:send("sp_" .. )

  table.sort(game_objects, function(a, b)
    return (a.frontness or 0) < (b.frontness or 0)
  end)
end

function game.update(dt)
  love.window.setTitle("FPS: " .. love.timer.getFPS())

  for i, v in ipairs(game_objects) do
    if v.update then
      v:update(dt)
    end
  end

  t = t + dt
  if online and t > update_time then
    for i, v in ipairs(game_objects) do
      if v.socket then
        v:socket()
      end
    end

    client:send("up_\n")

    data, _, _ = client:receive()

    while data do
      if data == "done" then
        break
      end
      action, id, value = data:match("(.*)_(.*)_(.*)")
      x, y, dx, dy = value:match("(.*):(.*):(.*):(.*)")
      x, y, dx, dy = tonumber(x), tonumber(y), tonumber(dx), tonumber(dy)
      id = tonumber(id)
      if id ~= player_id then
        if action == "pl" then
          if player_net[id] then
            player_net[id]:move(x, y, dx, dy)
          else
            player_net[id] = player_net_factory.make(x, y, dx, dy)
            player_net[id]:load()
          end
        elseif action == "pt" then
          if pet_net[id] then
            pet_net[id]:move(x, y, dx, dy)
          else
            pet_net[id] = pet_net_factory.make(x, y, dx, dy, "turtle")
            pet_net[id]:load()
          end
        end
      end
      data, _, _ = client:receive()
    end
  end

  for k, v in pairs(player_net) do
    v:update(dt)
  end
  for k, v in pairs(pet_net) do
    v:update(dt)
  end
end

function game.draw()
  for i, v in ipairs(game_objects) do
    if v.draw then
      v:draw()
    end
  end

  for k, v in pairs(player_net) do
    v:draw()
  end
  for k, v in pairs(pet_net) do
    v:draw()
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

      if r == 255 and g == 0 and b == 0 then
        make_block(x * 16, y * 16, "assets/dirt.png", 16, 16)
      elseif r == 0 and g == 255 and b == 255 then
        make_block(x * 16, y * 16, "assets/grass.png", 16, 16)
      elseif r == 0 and g == 0 and b == 255 then
        make_block(x * 16, y * 16, "assets/stone.png", 16, 16)
      elseif r == 255 and g == 255 and b == 0 then
        make_tile(x * 16, y * 16, "assets/tree.png")
      elseif r == 0 and g == 255 and b == 0 then
        make_tile(x * 16, y * 16, "assets/flowers.png", 200)
      elseif r == 0 and g == 0 and b == 0 then
        make_player(x * 16, y * 16)
      end
    end
  end
end

function make_player(x, y)
  local player_factory = require("src/entities/player")
  local player         = player_factory.make(x, y)

  table.insert(game_objects, player)

  player.pet = make_pet(x, y - 32)
end

function make_block(x, y, path, w, h) -- path is image
  local block_factory = require("src/entities/block")
  local block         = block_factory.make(x, y, w or 16, h or 16, path)

  table.insert(game_objects, block)
end

function make_tile(x, y, path, f) -- path is image
  f = f or 0

  local tile_factory = require("src/entities/tile")
  local tile         = tile_factory.make(x, y, path)

  tile.frontness = f

  table.insert(game_objects, tile)
end

function make_pet(x, y) -- path is image
  local i = math.floor(math.random(1, #pets))

  local pet_factory = require("src/entities/pet")
  local pet         = pet_factory.make(x, y, pets[i], i)

  table.insert(game_objects, pet)

  return pet
end

function make_food(x,y)
  local food_factory = require ("src/entities/food")
  local food = food_factory.make(x,y)

  table.insert(game_objects, food)
  return food
end

return game
