t1 = {
    {1,2,3},
    {4,5,6}, 
    {7,8,9}
}

t1_copy = {
    {1,2,3},
    {4,5,6}, 
    {7,8,9}
}

t2 = {
    {6,7,8},
    {9,10,11},
    {12,13,14}
}

t3 = {
    {1,2,3}
}

t4 = {
    {1,2,3,4},
    {5,6,7,8}, 
    {9,10,11,12}
}

t5 = {
    {2},
    {3},
    {4}
}

t6 = {
    {4,5} 
}

t7 = {
    {1,1,1},
    {1,1,1},
    {1,1,1}
}

r11 = {
    {30,36,42},
    {66,81,96},
    {102,126,150}
}

r12 = {
    {60,66,72},
    {141,156,171},
    {222,246,270}
}

r34 = {
    {38,44,50,56}
}

r35 = {
    {20}
}

r43 = nil

r56 = {
    {8,10},
    {12,15},
    {16,20}
}

function test_matrix_equal()
    assert(equalmat(t1,t1_copy))
end

function test_matrix_mul()
    assert(equalmat(matmul(t1,t1), r11))
    assert(equalmat(matmul(t1,t2), r12))
    assert(equalmat(matmul(t3,t4), r34))
    assert(equalmat(matmul(t4,t3), nil)) --expected error
    assert(equalmat(matmul(t3,t5), r35))
    assert(equalmat(matmul(t5,t6), r56))
end

function test_matrix_scale()
    scalemat(t7, 8)
    assert(equalmat(t7, {
        {8,8,8},
        {8,8,8},
        {8,8,8}
    }))
    scalemat(t7, 0.3)
    assert(equalmat(t7, {
        {8*0.3,8*0.3,8*0.3},
        {8*0.3,8*0.3,8*0.3},
        {8*0.3,8*0.3,8*0.3}
    }))
end

function test_copy_matrix()
    m1 = copymat(t1)
    equalmat(m1, t1)
end

test("matrix equal",test_matrix_equal)
test("matrix multiplication",test_matrix_mul)
test("matrix scaling", test_matrix_scale)
test("matrix copy", test_copy_matrix)