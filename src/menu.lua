local menu = {}

love.graphics.setBackgroundColor(130, 220, 250)

function math.lerp(a, b, k) --just fun stuff
  if a == b then return a else
    if math.abs(a-b) < 0.005 then return b else return a * (1-k) + b * k end
  end
end

WWIDTH, WHEIGHT = 800, 600

function menu:load()
  font = love.graphics.newFont(48)

  myStyle = uare.newStyle({

    width = 400,
    height = 60,

    color = {200, 200, 200},
    hoverColor = {150, 150, 150},
    holdColor = {100, 100, 100},

    border = {
      color = {255, 255, 255},
      hoverColor = {200, 200, 200},
      holdColor = {150, 150, 150},
      size = 5
    },

    text = {
      color = {200, 0, 0},
      hoverColor = {150, 0, 0},
      holdColor = {255, 255, 255},
      font = font,
      align = "center",
      offset = {
        x = 0,
        y = -30
      },
    },

  })

  myButton1 = uare.new({
    text = {
      display = "singleplayer"
    },
    onClick = function()
      state:switch("src/game", false)
    end,
    x = WWIDTH*.5-200,
    y = WHEIGHT*.5-200
  }):style(myStyle)

  myButton2 = uare.new({
    text = {
      display = "multiplayer"
    },
    onClick = function()
      state:switch("src/game", true)
    end,
    x = WWIDTH*.5-200,
    y = WHEIGHT*.5-100
  }):style(myStyle)
end

function menu:update(dt)
  uare.update(dt, love.mouse.getX(), love.mouse.getY())
end

function menu:draw()
  uare.draw()
end

function love.textinput(t)
  myButton1.text.display = myButton1.text.display .. t
end

return menu
