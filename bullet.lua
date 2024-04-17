BULLET_COLOR = 7
BULLET_SPEED = 3

function _bullet_update(bullet)
    bullet.y += BULLET_SPEED

    if bullet.y >= 127 then bullet.killed = true end
    if not bullet.killed then
        return bullet
    else
        return
    end
end

function _bullet_draw(bullet)
    line(bullet.x, bullet.y, bullet.x, bullet.y +5, BULLET_COLOR)
end

function make_bullet(x)
    local bullet = {}

    bullet.x = x
    bullet.y = 20 - 7
    bullet.killed = false

    bullet.update = _bullet_update
    bullet.draw = _bullet_draw

    return bullet
end