function create_mesh(tris)
    local r = {}
    r.tris = tris
    return r
end

function tan(a)
    return sin(a)/cos(a)
end

function project(v3d, project_mat)
    local r = vec_matmul(v3d, project_mat)
    if r.w~=0 then
        r *= (1/r.w)
    end
    return r
end

function pointat_mat(pos, v_lookdir, v_up, v_right)
    return {
        {v_right.x, v_right.y, v_right.z, 0},
        {v_up.x, v_up.y, v_up.z, 0},
        {v_lookdir.x, v_lookdir.y, v_lookdir.z, 0},
        {pos.x, pos.y, pos.z, 1}
    }
end

--inverse (only) the point at matrix
function pointat_inv(pointat_mat)
    local m = pointat_mat
    local a = vec3d:new(m[1][1],m[1][2],m[1][3])
    local b = vec3d:new(m[2][1],m[2][2],m[2][3])
    local c = vec3d:new(m[3][1],m[3][2],m[3][3])
    local t = vec3d:new(m[4][1],m[4][2],m[4][3])
    return{
        {a.x,b.x,c.x,0},
        {a.y,b.y,c.y,0},
        {a.z,b.z,c.z,0},
        {-t:dot(a),-t:dot(b),-t:dot(c),1}
    }
end

function _init()
    --front
    local p1 = vec3d:new(-0.5,-0.5,-0.5)
    local p2 = vec3d:new(-0.5,0.5,-0.5)
    local p3 = vec3d:new(0.5,0.5,-0.5)
    local p4 = vec3d:new(0.5,-0.5,-0.5)
    --back
    local p5 = vec3d:new(-0.5,-0.5,0.5)
    local p6 = vec3d:new(-0.5,0.5,0.5)
    local p7 = vec3d:new(0.5,0.5,0.5)
    local p8 = vec3d:new(0.5,-0.5,0.5)

    mesh = create_mesh({
        create_triangle({p1,p2,p3}),
        create_triangle({p1,p3,p4}),
        create_triangle({p4,p3,p7}),
        create_triangle({p4,p7,p8}),
        create_triangle({p8,p7,p6}),
        create_triangle({p8,p6,p5}),
        create_triangle({p5,p6,p2}),
        create_triangle({p5,p2,p1}),
        create_triangle({p2,p6,p7}),
        create_triangle({p2,p7,p3}),
        create_triangle({p8,p5,p1}),
        create_triangle({p8,p1,p4})
    })
end

mesh = {}

screen_w=128
screen_h=128
a = screen_w/screen_h
fov = 0.25
znear = 0.1
zfar = 1000
angle = 0
yaw = 0
xaw = 0
zaw = 0
v_camera = vec3d:new(0,0,0)
v_dir_light = vec3d:new(0,0,1)
v_lookdir = vec3d:new(0,0,1)
v_up = vec3d:new(0,1,0)
v_right = v_up:cross(v_lookdir)

--perspective projection matrix
--4x4 because we need to store the z value in the w place of the vector, and divide all other entries of the resulted vector by z
project_mat = {
    {a/tan(fov/2), 0, 0, 0},
    {0, 1/tan(fov/2), 0, 0},
    {0, 0, zfar/(zfar - znear), 1},
    {0, 0, (-zfar * znear)/(zfar - znear), 0}
}

function _update60()
    -- v_forward = vec3d:new(1,0,0):scale(v_lookdir.x)
    --                                :add(vec3d:new(0,0,1):scale(v_lookdir.z))
    --                                :normalized()
    --                                :scale(0.1) 
    v_forward = v_lookdir * 0.1
    if btn(0) then
        v_camera = v_camera + v_right * 0.1
    elseif btn(1) then
        v_camera = v_camera - v_right * 0.1
    end

    if btn(2) then
        v_camera = v_camera + v_forward
    elseif btn(3) then
        v_camera = v_camera - v_forward
    end

    if btn(4) then
        zaw=0.005
    elseif btn(5) then
        zaw=-0.005
    end

    if btn(0,1) then
        yaw=0.005
    elseif btn(1,1) then
        yaw=-0.005
    else
        yaw=0
    end
    if btn(2,1) then
        xaw=-0.005
    elseif btn(3,1) then
        xaw=0.005
    else
        xaw=0
    end

end

function _draw()
    cls(13)
    --rotate look direction
    v_lookdir = vec_rotate_around(v_lookdir, yaw, v_up):normalized()
    v_lookdir = vec_rotate_around(v_lookdir, xaw, v_right):normalized()
    
    --update new up and right vector based on rotated look direction
    local a = v_lookdir * v_up:dot(v_lookdir)
    v_up = (v_up - a):normalized()
    v_right = v_up:cross(v_lookdir) 

    local mat_camera = pointat_mat(v_camera, v_lookdir, v_up, v_right)

    local mat_view = pointat_inv(mat_camera)

    for tri in all(mesh.tris) do

        local tri_tmp = tri:copy()

        --rotate
        tri_tmp = tri_tmp:rotate(angle, angle, angle)

        --z offset into the screen
        tri_tmp = tri_tmp:add(vec3d:new(0,0,2))

        --front face culling
        --note: dot product (between camera and triangle normal) < 0 means the similarity between their directions is low, since the light cannot be reflected on the surface if the surface is facing at the same direction as the light source
        local camera2v = tri_tmp.vertices[1] - v_camera
        local light2v = tri_tmp.vertices[1] - v_dir_light
        local col = 11
        --cannot see triangle, not rendering
        if tri_tmp.normal:dot(camera2v) >= 0 then
            goto continue
        end
        --calculate light value
        local lum = -tri_tmp.normal:dot(v_dir_light)
        if lum >= 0 then
            if lum < 0.3333 then
                col = 5
            elseif lum < 0.666 then
                col = 6
            elseif lum < 1 then
                col = 7
            else
                col = 7
            end
        else
            col = 0
        end
        ------------------Render-----------------------

        --project to view space
        tri_tmp = tri_tmp:matmul(mat_view)

        --project to screen space
        local projected_vertices = {
            project(tri_tmp.vertices[1], project_mat),
            project(tri_tmp.vertices[2], project_mat),
            project(tri_tmp.vertices[3], project_mat)
        }
        tri_tmp = create_triangle(projected_vertices)

        --offset and scale
        tri_tmp = tri_tmp:add(vec3d:new(1,1,0)):mul(vec3d:new(0.5 * screen_w, 0.5 * screen_h, 1))

        tri_tmp:fill(col)
        --tri_tmp:draw(11)
        ::continue::
    end
    angle+=0.002
end
