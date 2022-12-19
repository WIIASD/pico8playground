vec2d = {
    x=0,
    y=0
}

function vec2d:new(x,y)
    local v = {}
    setmetatable(v, self)
    self.__index = vec2d
    self.__add = vec2d.add
    self.__sub = vec2d.sub
    self.__mul = vec2d.mul
    self.__div = vec2d.div
    self.__tostring = vec2d.tostr
    v.x = x or 0
    v.y = y or 0
    return v
end

function vec2d:copy()
    return vec2d:new(self.x, self.y)
end

function vec2d:tostr()
    return "{x="..self.x..", ".."y="..self.y.."}"
end

function vec2d:add(v)
    return vec2d:new(
        self.x + v.x,
        self.y + v.y
    )
end

function vec2d:sub(v)
    return vec2d:new(
        self.x - v.x,
        self.y - v.y
    )
end

function vec2d:mul(v)
    if type(v) == "number" then
        return vec2d:new(
            self.x * v,
            self.y * v
        )
    end
    return vec2d:new(
        self.x * v.x,
        self.y * v.y
    )
end

function vec2d:div(v)
    if type(v) == "number" then
        return vec2d:new(
            self.x / v,
            self.y / v
        )
    end
    return vec2d:new(
        self.x / v.x,
        self.y / v.y
    )
end

function vec2d:dot(v)
    return self.x * v.x+self.y * v.y
end

function vec2d:normalized()
    local l = sqrt(self.x * self.x + self.y * self.y)
    return vec2d:new(
        self.x/l,
        self.y/l
    )
end