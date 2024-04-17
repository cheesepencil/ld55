function collide_8x8(a, b)
    local aLeft = a.x
    local aTop = a.y
    local aRight = a.x + 8
    local aBottom = a.y + 8

    local bLeft = b.x
    local bTop = b.y
    local bRight = b.x + 8
    local bBottom = b.y + 8

    if (aTop > bBottom)  return false 
    if (bTop > aBottom)  return false 
    if (aLeft > bRight)  return false 
    if (bLeft > aRight)  return false 

    return true
end

function collide_line_sprite(l, s)
    local aLeft = l.x
    local aTop = l.y
    local aRigth = l.x
    local aBottom = l.y + 5

    local bLeft = s.x
    local bTop = s.y
    local bRigth = s.x + 8
    local bBottom = s.y + 8

    if (aTop > bBottom)  return false 
    if (bTop > aBottom)  return false 
    if (aLeft > bRigth)  return false 
    if (bLeft > aRigth)  return false 

    return true
end

function easeinelastic(t)
	if(t==0) return 0
	return 2^(10*t-10)*cos(2*t-2)
end

function lerp(a,b,t)
	return a+(b-a)*t
end