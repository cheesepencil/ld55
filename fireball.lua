FIREBALL_SPEED = 1

function _update_fireball(fireball)
    if fireball.y < -8 then return false end

    if t() % 0.5 == 0 then fireball.flip = not fireball.flip end

    fireball.y -= FIREBALL_SPEED
    return true
end

function _draw_fireball(fireball)
    spr(2, fireball.x, fireball.y, 1, 1, fireball.flip)
end

function make_fireball(x)
    local fireball = {}

    fireball.x = x
    fireball.y = 128
    fireball.flip = false

    fireball.update = _update_fireball
    fireball.draw = _draw_fireball

    return fireball
end