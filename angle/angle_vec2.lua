
function vline(p1, p2, col, full)
    if full then
        if (p2.vec.x-p1.vec.x) == 0 then
            line(p1.vec.x, 0, p1.vec.x, 127, col)
            return
        end
        local m=(p2.vec.y-p1.vec.y)/(p2.vec.x-p1.vec.x)
        local b=p1.vec.y-m*p1.vec.x
        local lpx1=0
        local lpy1=b
        local lpx2=127
        local lpy2=127*m+b
        line(lpx1, lpy1, lpx2, lpy2, col)
        return
    end
    line(p1.vec.x, p1.vec.y, p2.vec.x, p2.vec.y, col or 7)
end

function _init()
    poke(0x5f2d, 1)
    o = point:new(0, 0)
    p = point:new(30, 50, 10)
    p1 = point:new(64, 64, 11)
    p2 = point:new(70, 70, 12)
end

function _draw()
    cls()
    mx=stat(32)
    my=stat(33)
    mbtn1=stat(34)

    if mbtn1 == 1 then
        p = point:new(mx,my,p.col)
    else
        p2 = point:new(mx,my,p2.col)
    end

    vline(p, p1, 7, true)
    vline(p1, p2, p2.col, true)

    print("\fap,\fbp1,\fcp2\f7="..ang_ll(p,p1,p1,p2) * 360)

    p:draw()
    print("p", p.vec.x, p.vec.y + 6, p.col)
    p1:draw()
    print("p1", p1.vec.x, p1.vec.y + 6, p1.col)
    p2:draw()
    print("p2", p2.vec.x, p2.vec.y + 6, p2.col)
end

function rotate(p, a)
    return point:new(
        p.vec.x * cos(a) - p.vec.y * sin(a),
        p.vec.x * sin(a) + p.vec.y * cos(a),
        p.col
    )
end

function ang_ll(p1,p2,p3,p4)
    local l1 = p2.vec - p1.vec
    local l2 = p4.vec - p3.vec

    local a1 = atan2(l1.x, l1.y)

    local p1r = rotate(p1, -a1)
    local p2r = rotate(p2, -a1)
    local p3r = rotate(p3, -a1)
    local p4r = rotate(p4, -a1)

    local l1 = p2r.vec - p1r.vec
    local l2 = p4r.vec - p3r.vec
    

    return atan2(l2.x, l2.y) - atan2(l1.x, l1.y)
end

point = {}

function point:new(x,y,col)
    local p = {}
    p.col = col or 7
    p.vec = vec2d:new(x,y)
    p.draw = function(self)
        circfill(self.vec.x, self.vec.y, 2, self.col)
    end
    return p
end