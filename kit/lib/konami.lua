local lovemi = {name = "lovemi", instances = {}}
lovemi.__index = lovemi

function lovemi.add(f)

  assert(f and f.pattern, "Pattern required")

  local lovemiObj = f
  setmetatable(lovemiObj, lovemi)

  lovemiObj.enabled = true
  lovemiObj.active = false

  lovemiObj.time, lovemiObj.current = 0, 0

  table.insert(lovemi.instances, lovemiObj)

  return lovemiObj
end

function lovemi:updateSelf(dt)
  if self.active and self.duration then
    self.time = self.time + dt
    if self.time > self.duration then
      self.active = false
      self.current = 0
      if self.onEnd then self.onEnd() end
    end
  end
end

function lovemi:keypressedSelf(key, isrepeat)
  if not self.active then
    if key == self.pattern[self.current + 1] then
      self.current = self.current + 1
      if self.onSuccess then self.onSuccess() end

      if self.current == #self.pattern then
        self.active = self.duration and true or false
        self.current = self.duration and self.current or 0
        self.time = 0
        if self.onStart then self.onStart() end
      end
    elseif self.current ~= 0 then
      self.current = 0
      if self.onFail then self.onFail() end
    end
  end
end

function lovemi.update(dt)
  for i = #lovemi.instances, 1, -1 do
    if lovemi.instances[i] then
      lovemi.instances[i]:updateSelf(dt)
    end
  end
end

function lovemi:getLength()
  return #self.pattern
end

function lovemi:getPosition()
  return self.current
end

function lovemi:isActive()
  return self.active
end

function lovemi:remove()
  for i = #lovemi.instances, 1, -1 do
    if lovemi.instances[i] == self then table.remove(lovemi.instances, i) self = nil end
  end
end

function lovemi.clear()
  for i = 1, #lovemi.instances do lovemi.instances[i] = nil end
end

function lovemi.keypressed(key, isrepeat)
  for i = #lovemi.instances, 1, -1 do
    if lovemi.instances[i] then
      lovemi.instances[i]:keypressedSelf(key, isrepeat)
    end
  end
end

return lovemi
