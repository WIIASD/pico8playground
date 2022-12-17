function _init()
    poke(0x5f2d, 1)
    local joints = {
        {x=64, y=64},
        {x=63, y=63},
        {x=62, y=62},
        {x=61, y=61},
    }
    local lens = {
        25,25,25
    }
    c = chain:new(joints, lens)
end

function _draw()
    cls()
    mx=stat(32)
    my=stat(33)

    circfill(mx, my, 2, 11)

    c:solve({x=mx, y=my})
    c:draw()
end

function dist(p1, p2)
    return sqrt((p1.x - p2.x) * (p1.x - p2.x) + (p1.y - p2.y) * (p1.y - p2.y))
end

function add(p1, p2)
    return {x=p1.x+p2.x, y=p1.y+p2.y}
end

function scale(p, s)
    return {x=p.x*s, y=p.y*s}
end

chain = {}

function chain:new(joints, lens)
    local c = {}
    setmetatable(c, self)
    c.__index = chain
    c.draw = chain.draw
    c.solve = chain.solve
    c.lens = lens 
    c.joints = joints
    return c
end

-- https://www.researchgate.net/profile/Andreas-Aristidou/publication/273166356_Inverse_Kinematics_a_review_of_existing_techniques_and_introduction_of_a_new_fast_iterative_solver/links/54faeca10cf20b0d2cb8782b/Inverse-Kinematics-a-review-of-existing-techniques-and-introduction-of-a-new-fast-iterative-solver.pdf
function chain:solve(t)
    local p = self.joints
    local d = self.lens
    local dst = dist(p[1], t)
    local d_total = 0
    for i in all(d) do
        d_total += i 
    end
    if dst > d_total then
        for i=1, #p - 1, 1 do
            local ri = dist(t, p[i])
            local lami = d[i]/ri
            p[i+1] = add(
                scale(p[i], 1-lami), 
                scale(t, lami))
        end
    else
        local b = p[1]
        local difa = dist(p[#p], t)
        local tol = 0.1
        local max_try = 10
        local try = 0
        while difa > tol do
            --forward reaching
            p[#p] = t
            for i = #p - 1, 1, -1 do
                local ri = dist(p[i+1], p[i])
                local lami = d[i]/ri
                p[i] = add(
                    scale(p[i+1], 1-lami), 
                    scale(p[i],lami)
                )
            end
            --backward reaching
            p[1] = b
            for i=1, #p-1, 1 do
                local ri = dist(p[i+1], p[i])
                local lami = d[i]/ri
                p[i+1] = add(
                    scale(p[i], 1-lami),
                    scale(p[i+1], lami)
                )
            end
            difa = dist(p[#p], t)

            if try >= max_try then
                break
            end

            try+=1
        end
    end 
end

function chain:draw()
    local pre = nil
    for p in all(self.joints) do
        if pre then
            line(pre.x,pre.y,p.x,p.y,11)
        end
        pre = p
    end
    for p in all(self.joints) do
        circfill(p.x, p.y, 2, 10)
    end
end