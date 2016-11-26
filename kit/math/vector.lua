function make_vector(x, y)
  local vector = setmetatable({
    x = x, y = y,
  }, {
    __add = function(rhs)
      if type(rhs) == "number" then
        return make_vector(self.x + rhs, self.y + rhs)
      else
        return make_vector(self.x + rhs.x, self.y + rhs.y)
      end
    end,

    __sub = function(rhs)
      if type(rhs) == "number" then
        return make_vector(self.x - rhs, self.y - rhs)
      else
        return make_vector(self.x - rhs.x, self.y - rhs.y)
      end
    end,

    __mul = function(rhs)
      if type(rhs) == "number" then
        return make_vector(self.x * rhs, self.y * rhs)
      else
        return make_vector(self.x * rhs.x, self.y * rhs.y)
      end
    end,

    __div = function(rhs)
      if type(rhs) == "number" then
        return make_vector(self.x / rhs, self.y / rhs)
      else
        return make_vector(self.x / rhs.x, self.y / rhs.y)
      end
    end,

    __mod = function(rhs)
      if type(rhs) == "number" then
        return make_vector(self.x % rhs, self.y % rhs)
      else
        return make_vector(self.x % rhs.x, self.y % rhs.y)
      end
    end,
  })
end
