local menu = {}
local uare = require "uare"
function menu:load()

end

function menu:update(dt)
  uare.update(dt, love.mouse.getX(), love.mouse.getY())
end

function menu:draw()
  uare.draw()
end
myStyle = uare.new({
  width = 100, height = 100,
  color = {100,100,100},
  text = {
    color = {200,0,0}
  }
})

button = uare.new({
  text = {
    display = "button"
  },
  x = 200,
  y = 200
}):style(myStyle)

return menu
