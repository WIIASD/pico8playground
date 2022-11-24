function create_vec3d(x,y,z)
    local r = {}
    r.x = x
    r.y = y
    r.z = z
    r.tomat = function(self)
        return {{self.x,self.y,self.z}}
    end
    r.copy = function(self)
        return create_vec3d(self.x, self.y, self.z)
    end
    r.rotate = function(self, rotate_mat)
        local vmat = self:tomat()
        local rotated = matmul(vmat, rotate_mat)
        return create_vec3d(
            rotated[1][1],
            rotated[1][2],
            rotated[1][3]
        )
    end
    r.add = function(self, v)
        return create_vec3d(
            self.x + v.x,
            self.y + v.y,
            self.z + v.z
        )
    end
    r.scale = function(self, n)
        return create_vec3d(
            self.x * n,
            self.y * n,
            self.z * n
        )
    end
    r.dot = function(self, v)
        return self.x * v.x+self.y * v.y+self.z * v.z
    end
    r.cross = function(self, v)
        return create_vec3d(
            self.y * v.z - self.z * v.y,
            self.z * v.x - self.x * v.z,
            self.x * v.y - self.y * v.x
        )
    end
    r.normalized = function(self)
        local l = sqrt(self.x * self.x + self.y * self.y + self.z * self.z)
        return create_vec3d(
            self.x/l,
            self.y/l,
            self.z/l
        )
    end
    return r
end