local function fill_lower(v1,v2,v3, col)
	
	local inv_m1 = (v2.x-v1.x) / (v2.y-v1.y)
	local inv_m2 = (v3.x-v1.x) / (v3.y-v1.y)

	local cur_x1 = v1.x
	local cur_x2 = v1.x
	
	for y=v1.y, v2.y, 1 do
		line(cur_x1,y,cur_x2,y, col)
		cur_x1 += inv_m1
		cur_x2 += inv_m2
	end
end

local function fill_upper(v1,v2,v3, col)
	local inv_m1 = (v3.x-v1.x) / (v3.y-v1.y)
	local inv_m2 = (v3.x-v2.x) / (v3.y-v2.y)

	local cur_x1 = v3.x
	local cur_x2 = v3.x
	
	for sy=v3.y, v1.y, -1 do
		line(cur_x1,sy,cur_x2,sy, col)
		cur_x1 -= inv_m1
		cur_x2 -= inv_m2
	end
end

local function sort(tri)
    local tri_tmp = tri:copy()
    local tri_v = tri_tmp.vertices
	if tri_v[2].y < tri_v[1].y then
        tri_v[1], tri_v[2] = tri_v[2], tri_v[1]
    end
    if tri_v[3].y < tri_v[2].y then
        tri_v[2], tri_v[3] = tri_v[3], tri_v[2]
        if tri_v[2].y < tri_v[1].y then
            tri_v[1], tri_v[2] = tri_v[2], tri_v[1]
        end
    end
	return tri_tmp
end

function create_triangle(vertices)
    --private
    local calculate_normal = function(vertices)
        local line1 = vertices[2] - vertices[1]
        local line2 = vertices[3] - vertices[1]

        return line1:cross(line2):normalized()
    end

    local r = {}
    r.vertices = vertices
    r.normal = calculate_normal(r.vertices)
    r.draw = function(self, col)
        for i=1, 3, 1 do
            local np = i + 1
            if i + 1 > 3 then
                np = 1
            end
            line(self.vertices[i].x, self.vertices[i].y, self.vertices[np].x, self.vertices[np].y, col)
        end
    end
    r.fill = function(self, col)
        local sorted = sort(self)
        local v1 = sorted.vertices[1]
        local v2 = sorted.vertices[2]
        local v3 = sorted.vertices[3]

        if (v2.y == v3.y) then
            fill_lower(v1, v2, v3, col);
            return
        end
        if v1.y == v2.y then
            fill_upper(v1, v2, v3, col);
            return
        end

        local p = {
            x=(v1.x + ((v2.y - v1.y) / (v3.y - v1.y)) * (v3.x - v1.x)), 
            y=v2.y
        }

        fill_lower(v1,v2,p, col)
        fill_upper(v2,p,v3, col)
        line(p.x,p.y,v2.x,v2.y, col)
        --circfill(p.x,p.y,2,7)
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
            vec_rotate(self.vertices[1],a,b,c),
            vec_rotate(self.vertices[2],a,b,c),
            vec_rotate(self.vertices[3],a,b,c)
        })
    end
    r.add = function(self, v)
        return create_triangle({
            self.vertices[1]+v,
            self.vertices[2]+v,
            self.vertices[3]+v
        })
    end
    r.mul = function(self, v)
        return create_triangle({
            self.vertices[1]*v,
            self.vertices[2]*v,
            self.vertices[3]*v
        })
    end
    r.matmul = function(self, m)
        return create_triangle ({
            vec_matmul(self.vertices[1],m),
            vec_matmul(self.vertices[2],m),
            vec_matmul(self.vertices[3],m)
        })
    end
    return r
end