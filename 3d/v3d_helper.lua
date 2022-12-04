function vec_rotate(vec, a, b, c)
    --rotation matrix
    local rotation_xyz = {
        {cos(b)*cos(c), -cos(b)*sin(c), sin(b),0},
        {sin(a)*sin(b)*cos(c)+cos(a)*sin(c),cos(a)*cos(c)-sin(a)*sin(b)*sin(c),-sin(a)*cos(b),0},
        {sin(a)*sin(c)-cos(a)*sin(b)*cos(c),cos(a)*sin(b)*sin(c)+sin(a)*cos(c),cos(a)*cos(b),0},
        {0,0,0,1}
    }
    local r_mat = matmul(vec:tomat(), rotation_xyz)
    return vec3d:new(
        r_mat[1][1],
        r_mat[1][2],
        r_mat[1][3],
        r_mat[1][4]
    )
end
--rotate vec around v
function vec_rotate_around(vec, a, v)
    local x = v.x
    local y = v.y
    local z = v.z
    local c = cos(a)
    local s = sin(a)
    local nc = 1-c
    local rotation = {
        {x*x*nc+c,x*y*nc-z*s,x*z*nc+y*s,0},
        {y*x*nc+z*s,y*y*nc+c,y*z*nc-x*s,0},
        {z*x*nc-y*s,z*y*nc+x*s,z*z*nc+c,0},
        {0,0,0,1}
    }
    local r_mat = matmul(vec:tomat(), rotation)
    return vec3d:new(
        r_mat[1][1],
        r_mat[1][2],
        r_mat[1][3],
        r_mat[1][4]
    )
end

function vec_matmul(vec, m)
    local v = matmul(vec:tomat(),m)
    return vec3d:new(
        v[1][1],
        v[1][2],
        v[1][3],
        v[1][4]
    )
end