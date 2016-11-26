local state = {
  state = {},
  global = {
    update = {},
    draw   = {},
  },
}

setmetatable(state, state)

function state:new()
  return {}
end

function state:switch(path, args)
  if self.state.unload then
    self.state.unload()
  end

  local matches = {}

  for match in string.gmatch(path, "[^;]+") do
    matches[#matches + 1] = match
  end

  path = matches[1]

  package.loaded[path] = false

  self.state = require(path)

  if self.state.load then
    self.state.load(args)
  end

  return self
end

function state:update(dt)
  if self.state.update then
    self.state.update(dt)
  end

  return self
end

function state:draw()
  if self.state.update then
    self.state.draw()
  end

  return self
end

return state
