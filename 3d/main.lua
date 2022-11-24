function create_triangle(vertices)
    local r = {}
    r.vertices = vertices
    r.draw = function(self)
        for i=1, 3, 1 do
            local np = i + 1
            if i + 1 > 3 then
                np = 1
            end
            line(self.vertices[i].x, self.vertices[i].y, self.vertices[np].x, self.vertices[np].y)
        end
    end
    r.copy = function(self)
        return create_triangle({
            self.vertices[1]:copy(), 
            self.vertices[2]:copy(), 
            self.vertices[3]:copy()
        })
    end
    return r
end

function create_mesh(tris)
    local r = {}
    r.tris = tris
    return r
end

function tan(a)
    return sin(a)/cos(a)
end

mesh = {}

screen_w=128
screen_h=128
a = screen_w/screen_h
fov = 0.25
znear = 0.1
zfar = 1000
angle = 0
vCamera = create_vec3d(0,0,0)

rotate_x = {}
rotate_y = {}
rotate_z = {}

project_mat = {
    {a/tan(fov/2), 0, 0, 0},
    {0, 1/tan(fov/2), 0, 0},
    {0, 0, zfar/(zfar - znear), 1},
    {0, 0, (-zfar * znear)/(zfar - znear), 0}
}

function project(v3d, project_mat)
    local p_mat = v3d:tomat()
    add(p_mat[1], 1)
    local r = matmul(p_mat, project_mat)
    if r[1][4]~=0 then
        r[1][1] /= r[1][4]
        r[1][2] /= r[1][4]
        r[1][3] /= r[1][4]
    end
    return create_vec3d(r[1][1], r[1][2], r[1][3])
end

function _init()
    --front
    local p1 = create_vec3d(-0.5,-0.5,-0.5)
    local p2 = create_vec3d(-0.5,0.5,-0.5)
    local p3 = create_vec3d(0.5,0.5,-0.5)
    local p4 = create_vec3d(0.5,-0.5,-0.5)
    --back
    local p5 = create_vec3d(-0.5,-0.5,0.5)
    local p6 = create_vec3d(-0.5,0.5,0.5)
    local p7 = create_vec3d(0.5,0.5,0.5)
    local p8 = create_vec3d(0.5,-0.5,0.5)

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

function _draw()
    cls()
    for tri in all(mesh.tris) do

        local tri_tmp = tri:copy()

        --rotate
        for i=1, 3, 1 do
            tri_tmp.vertices[i] = tri_tmp.vertices[i]:rotate(rotate_x)
            tri_tmp.vertices[i] = tri_tmp.vertices[i]:rotate(rotate_y)
            tri_tmp.vertices[i] = tri_tmp.vertices[i]:rotate(rotate_z)
        end

        --translate
        for i=1, 3, 1 do
            tri_tmp.vertices[i].z += 2
        end
        
        --normal
        local line1 = create_vec3d(
            tri_tmp.vertices[2].x - tri_tmp.vertices[1].x,
            tri_tmp.vertices[2].y - tri_tmp.vertices[1].y,
            tri_tmp.vertices[2].z - tri_tmp.vertices[1].z
        )
        local line2 = create_vec3d(
            tri_tmp.vertices[3].x - tri_tmp.vertices[1].x,
            tri_tmp.vertices[3].y - tri_tmp.vertices[1].y,
            tri_tmp.vertices[3].z - tri_tmp.vertices[1].z
        )

        local normal = line1:cross(line2):normalized()

        --dot product between pointing from any point on the triangle to the camera (point-camera) and the normal vector
        if normal:dot(tri_tmp.vertices[1]:add(vCamera:scale(-1))) < 0 then
            --project
            local projected_vertices = {
                project(tri_tmp.vertices[1], project_mat),
                project(tri_tmp.vertices[2], project_mat),
                project(tri_tmp.vertices[3], project_mat)
            }
            tri_tmp = create_triangle(projected_vertices)
    
            --offset and scale
            for i=1, 3, 1 do
                tri_tmp.vertices[i].x+=1
                tri_tmp.vertices[i].y+=1
                tri_tmp.vertices[i].x*=0.5 * screen_w
                tri_tmp.vertices[i].y*=0.5 * screen_h
            end
    
            tri_tmp:draw()
        end

    end
end
