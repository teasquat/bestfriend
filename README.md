<<<<<<< HEAD
# bestfriend
A game for Coding Pirates Game Jam 2016
=======
# juicy-truffles
A Love/Lua kickstarter - game development kit

Global variables
---

- shack : *screen shaking handler*
- state : *game state handler*
- konami : *konami code handler*
- light_world : *light_world.lua world for handling lighting*
- world : *bump.lua world for collision handling*

Usage
---

As

```lua
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
```
>>>>>>> b084377ecab1cd29e2ebf87ef60cb4da74b90dd2
