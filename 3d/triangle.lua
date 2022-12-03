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
	local y1 = tri.vertices[1].y
	local y2 = tri.vertices[2].y
	local y3 = tri.vertices[3].y
	
	local v1_y = min(y1,min(y2,y3))
	local v2_y = mid(y1,y2,y3)
	local v3_y = max(y1,max(y2,y3))
	
    local old_tri = {
            {x=tri.vertices[1].x, y=y1},
            {x=tri.vertices[2].x, y=y2},
            {x=tri.vertices[3].x, y=y3}
        }
    local new_tri = {
            v1={},
            v2={},
            v3={}
        }
	for v in all(old_tri) do
		if v1_y == v.y then
			new_tri.v1.x =v.x
			new_tri.v1.y =v1_y
			del(old_tri, v)
			break
		end
	end
	for v in all(old_tri) do
		if v2_y == v.y then
			new_tri.v2.x =v.x
			new_tri.v2.y =v2_y
			del(old_tri, v)
			break
		end
	end
	for v in all(old_tri) do
		if v3_y == v.y then
			new_tri.v3.x =v.x
			new_tri.v3.y =v3_y
			del(old_tri, v)
			break	
		end
	end
	
	return new_tri
end

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
        local v1 = sorted.v1
        local v2 = sorted.v2
        local v3 = sorted.v3

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