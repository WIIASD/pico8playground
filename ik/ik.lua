--reference: https://www.youtube.com/watch?v=RTc6i-7N3ms&t=49s&ab_channel=TheCodingTrain

function _init()
    poke(0x5f2d, 1)
	s = seg:new(100,100,25)
	s1 = seg:new(64,64,25)
	ax = 64
	ay = 64
	tant = tentacle:new(ax, ay, 50, 2)
end

function _update60()

end

function _draw()
	cls()
	mx=stat(32)
    my=stat(33)
	
	circfill(64,64,1,7)
	circfill(mx,my,1,11)
	tant:follow(mx,my)
	tant:draw()
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
	t.follow = function(self, x, y)
		local s = self.segs
		s[#s] = s[#s]:follow(x, y)
		if #s != 1 then
			for i=#s - 1, 1, -1 do
				s[i] = s[i]:follow(s[i+1].tx, s[i+1].ty)
			end
			s[1] = seg:new(anchorx,anchory,s[1].len,s[1].angle)
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