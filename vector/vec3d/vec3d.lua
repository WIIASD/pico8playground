vec3d = {
    x=0,
    y=0,
    z=0,
    w=1
}

function vec3d:new(x,y,z,w)
    local v = {}
    setmetatable(v, self)
    self.__index = vec3d
    self.__add = vec3d.add
    self.__sub = vec3d.sub
    self.__mul = vec3d.mul
    self.__div = vec3d.div
    self.__tostring = vec3d.tostr
    v.x = x or 0
    v.y = y or 0
    v.z = z or 0
    v.w = w or 1
    return v
end

function vec3d:tomat()
    return {{self.x,self.y,self.z,self.w}}
end

function vec3d:copy()
    return vec3d:new(self.x, self.y, self.z)
end

function vec3d:tostr()
    return "{x="..self.x..", ".."y="..self.y..", ".."z="..self.z.."}"
end

function vec3d:add(v)
    return vec3d:new(
        self.x + v.x,
        self.y + v.y,
        self.z + v.z
    )
end

function vec3d:sub(v)
    return vec3d:new(
        self.x - v.x,
        self.y - v.y,
        self.z - v.z
    )
end

function vec3d:mul(v)
    if type(v) == "number" then
        return vec3d:new(
            self.x * v,
            self.y * v,
            self.z * v
        )
    end
    return vec3d:new(
        self.x * v.x,
        self.y * v.y,
        self.z * v.z
    )
end

function vec3d:div(v)
    if type(v) == "number" then
        return vec3d:new(
            self.x / v,
            self.y / v,
            self.z / v
        )
    end
    return vec3d:new(
        self.x / v.x,
        self.y / v.y,
        self.z / v.z
    )
end

function vec3d:dot(v)
    return self.x * v.x+self.y * v.y+self.z * v.z
end

function vec3d:cross(v)
    return vec3d:new(
        self.y * v.z - self.z * v.y,
        self.z * v.x - self.x * v.z,
        self.x * v.y - self.y * v.x
    )
end

function vec3d:normalized()
    local l = sqrt(self.x * self.x + self.y * self.y + self.z * self.z)
    return vec3d:new(
        self.x/l,
        self.y/l,
        self.z/l
    )
end