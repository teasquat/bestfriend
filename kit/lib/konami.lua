local konami = {
  name = "konami",
  instances = {},
}

setmetatable(konami, konami)

function konami.add(f)
  assert(f and f.pattern, "Why would you add a pattern ... with no pattern?")

  local obj = f
  setmetatable(obj, konami)

  obj.enabled = true
  obj.active  = false

  obj.time, obj.current = 0, 0

  table.insert(konami.instances, obj)

  return obj
end

function konami:update_self(dt)
  if self.active and self.duration then
    self.time = self.time + dt

    if self.time > self.duration then
      self.active  = false
      self.current = 0

      if self.on_end then
        self.on_end()
      end
    end
  end
end

function konami:keypressed_self(key)
  if not self.active then
    if key == self.pattern[self.current + 1] then
      self.current = self.current + 1

      if self.on_success then
        self.on_success()
      end

      if self.current == #self.pattern then
        self.active  = self.duration or false
        self.current = self.duration and self.current or 0
        self.time = 0

        if self.on_start then
          self.on_start()
        end
      end
    elseif self.current ~= 0 then
      self.current = 0

      if self.on_fail then
        self.on_fail()
      end
    end
  end
end

function konami.update(dt)
  for i = #konami.instances, 1, -1 do
    if konami.instances[i] then
      konami.instances[i]:update_self(dt)
    end
  end
end

function konami:get_length()
  return #self.pattern
end

function konami:get_position()
  return self.current
end

function konami:is_active()
  return self.active
end

function konami:remove()
  for i = #konami.instances, 1, -1 do
    if konami.instances[i] == self then
      table.remove(konami.instances, i)
      self = nil
    end
  end
end

function konami.clear()
  for i = 1, #konami.instances do
    konami.instances[i] = nil
  end
end

function konami.keypressed(key)
  for i = #konami.instances, 1, -1 do
    if konami.instances[i] then
      konami.instances[i]:keypressed_self(key)
    end
  end
end

return konami
