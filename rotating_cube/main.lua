pts = {} --points
angle = 0
is_to_ss = 128 -- image space to screen space scale
fov = 0.33333 --120
distance = 200 --distance from eye to obj
offset = 64

projection = {
    {1,0},
    {0,1},
    {0,0}
}

rotate_x = {}
rotate_y = {}
rotate_z = {}

function _init()
    add(pts, {{-0.5,-0.5,-0.5}}) 
    add(pts, {{0.5,-0.5,-0.5}}) 
    add(pts, {{0.5,0.5,-0.5}}) 
    add(pts, {{-0.5,0.5,-0.5}})
    add(pts, {{-0.5,-0.5,0.5}}) 
    add(pts, {{0.5,-0.5,0.5}}) 
    add(pts, {{0.5,0.5,0.5}}) 
    add(pts, {{-0.5,0.5,0.5}})
end

function connect(i1, i2, pts)
    if i1 > #pts or i2 > #pts or i1 < 1 or i2 < 1 then
        return
    end
    line(pts[i1][1][1], pts[i1][1][2], pts[i2][1][1], pts[i2][1][2], 7)
end

function _update60()

    rotate_x = {
        {1,0,0},
        {0, cos(angle), -sin(angle)},
        {0, sin(angle), cos(angle)},
    }     
    rotate_y = {
        {cos(angle), 0, sin(angle)},
        {0, 1, 0},
        {-sin(angle), 0, cos(angle)}
    }  
    rotate_z = {
        {cos(angle), -sin(angle),0},
        {sin(angle), cos(angle),0},
        {0,0,1}
    }
    
    angle+=0.002
end

function tan(a)
    return sin(a)/cos(a)
end

function _draw()
    cls(1)
    projected = {}
    for i=1, #pts, 1 do
        --rotation
        local p = copymat(pts[i])
        p = matmul(p, rotate_x)
        p = matmul(p, rotate_y)
        p = matmul(p, rotate_z)

        --perspective projection
        local pj = copymat(projection)
        p[1][3]+=distance/is_to_ss -- offset z of the obj by normalized distance
        scalemat( pj, 1/(p[1][3] * tan((fov/2))) ) --scale x and y by 1/(z * tan(fov/2))
        p = matmul(p, pj)
        
        local color = 14
        -- if p[1][3] < 0 then
        --     color = 2
        -- end

        --orthographic projection
        --p = matmul(projection, p)

        --scaling and offsetting
        scalemat(p, is_to_ss)
        add_mat_const(p, offset)
        add(projected, p)
        circfill(p[1][1], p[1][2], 2, color)
    end

    for i=0, 3, 1 do
        connect(i + 1, (i+1) % 4 + 1, projected)
        connect(i + 4 + 1, ((i+1) % 4) + 4 + 1, projected)
        connect(i + 1, i + 4 + 1, projected)
    end

end
