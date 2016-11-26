local player_factory = {}

function player_factory.make(x, y)
  local player = {
    frontness = 100,
    x = x, y = y,
    -- velocity
    dx = 0,
    dy = 0,
    -- movement
    acc  = 30,   -- acceleration
    frcx = 0.1,  -- friction x
    frcy = 1.5,  -- friction y
    -- (kinda-lol) static
    w = 16,     -- width
    h = 16,     -- height

    right = "right",
    left  = "left",
    jump  = "x",
    pew   = "c",
    -- jumping
    grounded   = false,  -- whether or not am touching ground
    jump_force = 7,      -- how much force to apply when normal jumping
    -- wall jumping
    wall_force = 6,      -- how much force to apply when wall jumping
    wall       = 0,
    -- static
    gravity    = 30,
    -- pet stuff
    pet = nil,
    picked_up = true,
    -- status
    status = "ignore",
    -- animation
    walk      = {},
    walk_n    = {},
    neutral   = {},
    neutral_n = {},

    index   = 1,
    dir     = 1,
    tshirt = {},
    beard = {},
    tshirt_image = nil,
    beard_image = nil
  }

  function player:load()
    world:add(self, self.x, self.y, self.w, self.h)

    self.walk[1] = love.graphics.newImage("assets/player/walk1.png")
    self.walk[2] = love.graphics.newImage("assets/player/walk2.png")

    self.walk_n[1] = love.graphics.newImage("assets/player/walk_n1.png")
    self.walk_n[2] = love.graphics.newImage("assets/player/walk_n2.png")

    self.neutral[1] = love.graphics.newImage("assets/player/neutral.png")
    self.neutral_n[1] = love.graphics.newImage("assets/player/neutral_n.png")

    self.current = self.walk
    self.tshirt = {r = math.random(50, 230), g = math.random(50, 230), b=math.random(50, 230) }
    self.beard = {r = math.random(50, 230), g = math.random(50, 230), b=math.random(50, 230) }
    self.tshirt_image = love.graphics.newImage("assets/cosmetics/tshirt" .. math.random(1,2) .. ".png")
    self.beard_image = love.graphics.newImage("assets/cosmetics/beard1.png")

    -- bad konami stuff
    local pet_ref = self.pet
    self.konami_rainbow = konami.add({
      pattern = {"left", "right", "right", "left", "x", "x", "c", "x"},
      onStart = function()
        pet_ref.rainbow_stuff = true
      end,
    })
  end

  function player:update(dt)
    konami.update(dt)

    self.index = self.index + dt * 2 * self.dx
    self.dir = math.sign(self.dx) or self.dir

    if self.picked_up then
      self.pet.dir = self.dir
    end

    local still = self.dx < 0.005 and self.dx > -0.005

    if self.picked_up then
      if still then
        self.current = self.neutral_n
      else
        self.current = self.walk
      end
    else
      if still then
        self.current = self.neutral
      else
        self.current = self.walk_n
      end
    end

    if love.keyboard.isDown(self.right) then
      self.dx = self.dx + self.acc * dt
    end

    if love.keyboard.isDown(self.left) then
      self.dx = self.dx - self.acc * dt
    end

    self.dx = self.dx - self.wall * dt

    self.dy = self.dy + self.gravity * dt

    -- friction
    self.dx = self.dx - (self.dx / self.frcx) * dt
    self.dy = self.dy - (self.dy / self.frcy) * dt

    -- movement
    self.x, self.y, self.cols = world:move(self, self.x + self.dx, self.y + self.dy, ignore_filter)

    self.grounded = false

    local ww, wh = camera:view_dimensions()
    camera.x = math.lerp(camera.x, self.x + self.w / 2 - ww / 2, dt * 3) -- interpolate camera towards player
    camera.y = math.lerp(camera.y, self.y + self.h / 2 - wh / 1.45, dt * 2.5) -- interpolate camera towards player

    self.wall = 0
    for i, v in ipairs(self.cols) do
      if v.normal.y ~= 0 then
        if v.normal.y == -1 then

          local shake   = self.dy * 2
          local epsilon = 2
          if shake < epsilon then
            shake = 0
          elseif -shake > -epsilon then
            shake = 0
          end

          --shack:set_shake(shake)

          self.grounded = true
        end
        if v.other ~= self.pet then
          self.dy = 0
        end
      end

      if v.normal.x ~= 0 then
        self.dx = 0

        if not self.grounded then
          self.wall = v.normal.x
        end
      end
    end

    if self.picked_up then
      self.pet.y = self.y - self.h
      self.pet.x = self.x
    end
  end

  function player:draw()
    -- TODO: make good graphics
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(self.current[math.floor(self.index % #self.current) + 1], self.x + self.w / 2, self.y, 0, self.dir, 1, self.w / 2)
    love.graphics.setColor(self.tshirt.r, self.tshirt.g, self.tshirt.b)
    love.graphics.draw(self.tshirt_image, self.x + self.w / 2, self.y, 0, self.dir, 1, self.w / 2)
    love.graphics.setColor(self.beard.r, self.beard.g, self.beard.b)
    love.graphics.draw(self.beard_image, self.x + self.w / 2, self.y, 0, self.dir, 1, self.w / 2)
  end

  function player:throw()
    if self.picked_up then
      self.picked_up     = false
      self.pet.picked_up = false

      local throw_x, throw_y = self.dx, self.dy

      if throw_x + throw_y < 0.5 and throw_x + throw_y > -0.5 then
        if throw_y < 0.005 and throw_y > -0.005 then
          throw_y = throw_y - 1.5
        end

        if throw_x < 0.5 and throw_x > -0.5 then
          throw_x = throw_x * 10
        end

        if throw_y < 0.5 and throw_y > -0.5 then
          throw_y = throw_y * 10
        end
      end
      self.pet.dx = throw_x * 5
      self.pet.dy = throw_y * 4
    end
  end

  function player:pick_up()
    for i, v in ipairs(self.cols) do
      if v.other == self.pet then
        self.picked_up     = true
        self.pet.picked_up = true
      end
    end
  end

  function player:press(key, isrepeat)
    konami.keypressed(key, isrepeat)
    if key == self.jump then
      if self.grounded then
        self.dy = -self.jump_force
      elseif self.wall ~= 0 then
        self.dy = -self.wall_force
        self.dx = self.wall_force / 1.5 * self.wall
      end
    elseif key == self.pew then
      if self.picked_up then
        self:throw()
      else
        self:pick_up()
      end
    end
  end

  function player:socket()
    client:send("pl_" .. self.x .. ":" .. self.y .. ":" .. self.dx .. ":" .. self.dy .. "\n")
  end

  return player
end

return player_factory
