pico-8 cartridge // http://www.pico-8.com
version 38
__lua__
--algorithm from: http://www.sunshine2k.de/coding/java/TriangleRasterization/TriangleRasterization.html
function _init()
	tri = {
		v1={x=rnd(127), y=rnd(127)},
		v2={x=rnd(127), y=rnd(127)},
		v3={x=rnd(127), y=rnd(127)}
	}
	sorted_tri = sort(tri)
end

function _update60()
	if btnp(❎) then
		tri = {
			v1={x=rnd(127), y=rnd(127)},
			v2={x=rnd(127), y=rnd(127)},
			v3={x=rnd(127), y=rnd(127)}
		}
		sorted_tri = sort(tri)
	end
end

function _draw()
	cls()
	
	fill(sorted_tri)
	--fill_upper(tri.v1,tri.v2,tri.v3)
	
	line(tri.v1.x,
						tri.v1.y,
						tri.v2.x,
						tri.v2.y,
						11
					)
	line(tri.v2.x,
						tri.v2.y,
						tri.v3.x,
						tri.v3.y
					)
	line(tri.v3.x,
						tri.v3.y,
						tri.v1.x,
						tri.v1.y
					)
	
		
	print(""..tostr(tri.v1.x).." "..tostr(tri.v1.y),7)
	print(""..tostr(tri.v2.x).." "..tostr(tri.v2.y))
	print(""..tostr(tri.v3.x).." "..tostr(tri.v3.y))

	print("   ")

	print(""..tostr(sorted_tri.v1.x).." "..tostr(sorted_tri.v1.y))
	print(""..tostr(sorted_tri.v2.x).." "..tostr(sorted_tri.v2.y))
	print(""..tostr(sorted_tri.v3.x).." "..tostr(sorted_tri.v3.y))

end
-->8
function sort(tri)
	local y1 = tri.v1.y
	local y2 = tri.v2.y
	local y3 = tri.v3.y
	
	local v1_y = min(y1,min(y2,y3))
	local v2_y = mid(y1,y2,y3)
	local v3_y = max(y1,max(y2,y3))
	
 local old_tri = {
		{x=tri.v1.x, y=y1},
		{x=tri.v2.x, y=y2},
		{x=tri.v3.x, y=y3}
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
-->8
function fill(tri)
	local v1 = tri.v1
 local v2 = tri.v2
 local v3 = tri.v3
	local m = (v3.y-v1.y) / (v3.x-v1.x)
	local b = v3.y - m * v3.x
	local p = {x=(v2.y-b)/m,y=v2.y}
	
 fill_lower(v1,v2,p)
 line(p.x,p.y,v2.x,v2.y,10)
	fill_upper(v2,p,v3)
end

function fill_lower(v1,v2,v3)
	
	local inv_m1 = (v2.x-v1.x) / (v2.y-v1.y)
	local inv_m2 = (v3.x-v1.x) / (v3.y-v1.y)

	local cur_x1 = v1.x
	local cur_x2 = v1.x
	
	for y=v1.y, v2.y, 1 do
		line(cur_x1,y,cur_x2,y,10)
		cur_x1 += inv_m1
		cur_x2 += inv_m2
	end
end

function fill_upper(v1,v2,v3)
	local inv_m1 = (v3.x-v1.x) / (v3.y-v1.y)
	local inv_m2 = (v3.x-v2.x) / (v3.y-v2.y)

	local cur_x1 = v3.x
	local cur_x2 = v3.x
	
	for sy=v3.y, v1.y, -1 do
		line(cur_x1,sy,cur_x2,sy,10)
		cur_x1 -= inv_m1
		cur_x2 -= inv_m2
	end
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
