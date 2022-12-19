pico-8 cartridge // http://www.pico-8.com
version 38
__lua__
function _init()
	poke(0x5f2d, 1)
	
end

function _draw()
	 cls()
	 mx=stat(32)
  my=stat(33)
	 p = {x=30, y=50, col = 10}
		p1 = {x=mx, y=my, col = 11}
		p2 = {x=64, y=64, col = 10}
		pj = project(p1,p,p2)
	 local o = {x=0,y=0}
	 
		full_line(p,p2,10)
		full_line(p2,p1,p1.col)
	 
	 print(ang_l(p,p2))
	 print(ang_l(p2,p1))
	 print(ang_ll(p2,pj,p2,p1))
	 --print
	 
	 circfill(p.x,p.y,2,p.col)
	 circfill(p1.x,p1.y,2,p1.col)
	 circfill(p2.x,p2.y,2,p2.col)
	 --circfill(pj.x,pj.y,2,9)
end

function ang(p)
	return 360*atan2(p.x,p.y)
end

function slope(p1,p2)
	return (p2.y-p1.y)/(p2.x-p1.x)
end

function full_line(p1,p2,col)
	local m=slope(p1,p2)
	local b=p1.y-m*p1.x
	local lpx1=0
	local lpy1=b
	local lpx2=127
	local lpy2=127*m+b
	line(lpx1,lpy1,lpx2,lpy2,col)
end

function ang_l(p1,p2)
	local m=slope(p1,p2)
	local dum_y=1
	if p2.y < p1.y then
		dum_y=-1
	end
	local x=dum_y/m
	return atan2(x,dum_y) * 360
end

function ang_ll(p1,p2,p3,p4)
	local m1=slope(p1,p2)
	local m2=slope(p3,p4)
	
	local dum_y=1
	local x1=dum_y/m1
	local x2=dum_y/m2
	
	return (atan2(x1,dum_y)
								-
								atan2(x2,dum_y)) * 360
end

function ang_lll(p1,p2,p3,p4)
	
end

function project(pp,p1,p2)
	local m1=slope(p1,p2)
	local m2=-1/m1
	local b1=p1.y-m1*p1.x
	local b2=pp.y-m2*pp.x
	
	local rx=(b2-b1)/(m1-m2)
	local ry=m1*rx+b1
	
	return {x=rx,y=ry}
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
