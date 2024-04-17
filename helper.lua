function collide_8x8(a, b)
    local aLeft = a.x
    local aTop = a.y
    local aRigth = a.x + 8
    local aBottom = a.y + 8

    local bLeft = b.x
    local bTop = b.y
    local bRigth = b.x + 8
    local bBottom = b.y + 8

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