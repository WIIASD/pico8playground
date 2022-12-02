function create_triangle(vertices)
    --private
    local calculate_normal = function(vertices)
        local line1 = vertices[2]:sub(vertices[1])
        local line2 = vertices[3]:sub(vertices[1])

        return line1:cross(line2):normalized()
    end

    local r = {}
    r.vertices = vertices
    r.normal = calculate_normal(r.vertices)
    r.draw = function(self)
        for i=1, 3, 1 do
            local np = i + 1
            if i + 1 > 3 then
                np = 1
            end
            line(self.vertices[i].x, self.vertices[i].y, self.vertices[np].x, self.vertices[np].y)
        end
    end
    r.fill = function(self)
        --sort vertices according to y value
        --choose v2 as p1
        --find inverse slope, inv_m, of the line v1 --> v3
        --curx = v1.x
        --for y=v1.y, y>=v3.y, y--
            --line(curx, y)
            --curx -= inv_m
    end
    r.copy = function(self)
        return create_triangle({
            self.vertices[1]:copy(), 
            self.vertices[2]:copy(), 
            self.vertices[3]:copy()
        })
    end
    r.rotate = function(self, a, b, c)
        return create_triangle({
            self.vertices[1]:rotate(a,b,c),
            self.vertices[2]:rotate(a,b,c),
            self.vertices[3]:rotate(a,b,c)
        })
    end
    r.add = function(self, v)
        return create_triangle({
            self.vertices[1]:add(v),
            self.vertices[2]:add(v),
            self.vertices[3]:add(v)
        })
    end
    r.scale = function(self, n)
        return create_triangle({
            self.vertices[1]:scale(n),
            self.vertices[2]:scale(n),
            self.vertices[3]:scale(n)
        })
    end
    r.mul = function(self, v)
        return create_triangle({
            self.vertices[1]:mul(v),
            self.vertices[2]:mul(v),
            self.vertices[3]:mul(v)
        })
    end
    r.matmul = function(self, m)
        return create_triangle ({
            self.vertices[1]:matmul(m),
            self.vertices[2]:matmul(m),
            self.vertices[3]:matmul(m)
        })
    end
    return r
end