function create_vec3d(x,y,z,w)
    local r = {}
    r.x = x
    r.y = y
    r.z = z
    r.w = w or 1 --place holder for calculation
    r.tomat = function(self)
        return {{self.x,self.y,self.z,self.w}}
    end
    r.copy = function(self)
        return create_vec3d(self.x, self.y, self.z)
    end
    r.rotate = function(self, a, b, c)
        --rotation matrix
        local rotation_xyz = {
            {cos(b)*cos(c), -cos(b)*sin(c), sin(b),0},
            {sin(a)*sin(b)*cos(c)+cos(a)*sin(c),cos(a)*cos(c)-sin(a)*sin(b)*sin(c),-sin(a)*cos(b),0},
            {sin(a)*sin(c)-cos(a)*sin(b)*cos(c),cos(a)*sin(b)*sin(c)+sin(a)*cos(c),cos(a)*cos(b),0},
            {0,0,0,1}
        }
        local r_mat = matmul(self:tomat(), rotation_xyz)
        return create_vec3d(
            r_mat[1][1],
            r_mat[1][2],
            r_mat[1][3],
            r_mat[1][4]
        )
    end
    r.rotate_around = function(self, a, v)
        local x = v.x
        local y = v.y
        local z = v.z
        local c = cos(a)
        local s = sin(a)
        local nc = 1-c
        local rotation = {
            {x*x*nc+c,x*y*nc-z*s,x*z*nc+y*s,0},
            {y*x*nc+z*s,y*y*nc+c,y*z*nc-x*s,0},
            {z*x*nc-y*s,z*y*nc+x*s,z*z*nc+c,0},
            {0,0,0,1}
        }
        local r_mat = matmul(self:tomat(), rotation)
        return create_vec3d(
            r_mat[1][1],
            r_mat[1][2],
            r_mat[1][3],
            r_mat[1][4]
        )
    end
    r.add = function(self, v)
        return create_vec3d(
            self.x + v.x,
            self.y + v.y,
            self.z + v.z
        )
    end
    r.sub = function(self, v)
        return create_vec3d(
            self.x - v.x,
            self.y - v.y,
            self.z - v.z
        )
    end
    r.scale = function(self, n)
        return create_vec3d(
            self.x * n,
            self.y * n,
            self.z * n
        )
    end
    r.mul = function(self, v)
        return create_vec3d(
            self.x * v.x,
            self.y * v.y,
            self.z * v.z
        )
    end
    r.matmul = function(self, m)
        local v = matmul(self:tomat(),m)
        return create_vec3d(
            v[1][1],
            v[1][2],
            v[1][3],
            v[1][4]
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