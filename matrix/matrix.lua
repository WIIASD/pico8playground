
function matmul(m1, m2)
  
  local m1_row_count = #m1
  local m2_row_count = #m2
  local m1_col_count = #m1[1]
  local m2_col_count = #m2[1]
  
  if m1_col_count ~= m2_row_count then
    print("m1 col count must equal to m2 row count!", 8)
    return
  end
  
  result = {}
  
  for m1_row=1, m1_row_count, 1 do
    
    add(result, {})
    
    for m2_col=1, m2_col_count, 1 do
      local row = m1[m1_row]
      local col = {}
      local sum = 0
      
      for j=1, m2_row_count, 1 do
        add(col, m2[j][m2_col])
      end
      
      for i=1, #row, 1 do
        sum = sum + row[i] * col[i]
      end
      
      add(result[m1_row], sum)
    end
    
  end
  
  return result
end

function copymat(m)
  result = {}
  for i=1, #m, 1 do
    add(result, {})
    for j=1, #m[1], 1 do
      add(result[i], m[i][j])
    end
  end
  return result
end

function scalemat(m, scale)
  for i=1, #m, 1 do
    for j=1, #m[1], 1 do
      m[i][j] *= scale
    end
  end
end

function add_mat_const(m, n)
  for i=1, #m, 1 do
    for j=1, #m[1], 1 do
      m[i][j] += n
    end
  end
end

function equalmat(m1, m2)
  if m1 == nil or m2 == nil then
    return m1==m2
  end

  if #m1 ~= #m2 or #m1[1] ~= #m2[1] then
    return false
  end

  for i=1, #m1, 1 do
    for j=1, #m1[1], 1 do
      if m1[i][j] ~= m2[i][j] then
        return false
      end
    end
  end

  return true
end

function printmat(m)
  str = ""
  for i=1,#m,1 do
    for j=1,#m[1],1 do
      str = str .. tostr(m[i][j]) .. " "
    end
    str = str .. "\n"
  end
  print(str)
end