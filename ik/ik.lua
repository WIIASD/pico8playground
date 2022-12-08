--reference: https://www.youtube.com/watch?v=RTc6i-7N3ms&t=49s&ab_channel=TheCodingTrain

function _init()
    poke(0x5f2d, 1)
	s = seg:new(100,100,25)
	s1 = seg:new(64,64,25)
	tant = tentacle:new(64, 64, 2, 25, -20)
	--tant.segs[1].len = 15
	groundy = 70
	px = tant.anchorx - 30
	pnow = px
end

function _update60()
	if btn(0) then
		tant.anchorx-=1
	elseif btn(1) then
		tant.anchorx+=1
	end

	if btn(2) then
		tant.anchory-=1
	elseif btn(3) then
		tant.anchory+=1
	end
end

function _draw()
	cls()
	mx=stat(32)
    my=stat(33)
	px = tant.anchorx - 30
	pclose = tant.anchorx - 14
	pfar = tant.anchorx - 45


	line(0,groundy, 127, groundy)

	circfill(tant.anchorx,tant.anchory,1,7)
	circfill(px, groundy, 1, 11)
	circfill(pclose, groundy, 1, 11)
	circfill(pfar, groundy, 1, 11)
	circfill(mx,my,1,11)

	print(tant.segs[1].angle)
	print(tant.segs[2].angle)
	print(tant.segs[1].angle - tant.segs[2].angle)

	if pnow < pfar or pnow > pclose then
		pnow = px
	end
	tant:follow(pnow,groundy)
	-- tant:follow(mx, my)
	tant:draw()
end

function clamp(a, min, max)
	local new_a = a
	if new_a < min then
		new_a = min
	elseif new_a > max then
		new_a = max
	end
	return new_a
end

tentacle={}

function tentacle:new(anchorx, anchory, num, len)
	local function create_segs()
		local r = {}
		for i=1, num, 1 do
			add(r, seg:new(anchorx, anchory, len))
		end
		return r
	end
	local t = {}
	t.num = num
	t.len = len
	t.anchorx = anchorx
	t.anchory = anchory
	t.segs = create_segs()
	t.draw = function(self)
		for s in all(self.segs) do
			s:draw()
		end
	end
	t.angle_btw = function(self, i, j)
		return self.segs[i].angle - self.segs[j].angle
	end
	t.follow = function(self, x, y)
		local s = self.segs
		s[#s] = s[#s]:follow(x, y)
		if #s > 1 then
			for i=#s - 1, 1, -1 do
				s[i] = s[i]:follow(s[i+1].tx, s[i+1].ty)
			end
			
			--specific to left leg, should not exist in normal ik follow
			local new_a = clamp(s[1].angle, 0.5, 1)

			s[1] = seg:new(self.anchorx,self.anchory,s[1].len, new_a)
			for i=2, #s, 1 do
				s[i] = seg:new(s[i-1].hx,s[i-1].hy, s[i].len, s[i].angle)
			end
		else
			s[1] = seg:new(anchorx,anchory,s[1].len,s[1].angle)
		end
	end
	return t
end

seg = {}

function seg:new(x,y,len,angle)
	local s = {}
	s.tx = x
	s.ty = y
	s.hx = x+len * cos(angle)
	s.hy = y-len * sin(angle)
    s.len = len
    s.angle = angle or 0
	s.draw = function(self)
		line(self.tx,self.ty,self.hx,self.hy,7)
	end
	s.offset = function(self,x,y)
		return seg:new(self.tx+x, self.ty+y, self.len, self.angle)
	end
	s.follow = function(self, x, y)
		local sp = self:point(x,y)
		local s1 = seg:new(x, y, sp.len, sp.angle + 0.5)
		s1 = seg:new(s1.hx, s1.hy, s1.len, sp.angle)
		return s1
	end
	s.point = function(self,x,y)
		local rx = x - self.tx
		local ry = y - self.ty
		
		s_tmp = seg:new(0, 0, self.len, self.angle)
		local a = self.angle + atan2(s_tmp.hx,s_tmp.hy) - atan2(rx, ry)
		
		return seg:new(self.tx,self.ty,self.len,a)
	end
	return s
end