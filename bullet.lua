BULLET_COLOR = 7
BULLET_SPEED = 3
BULLET_MAX_COUNT = 1
BULLET_COOLDOWN = 0.125

function _bullet_update(bullet)
    bullet.y += BULLET_SPEED

    if bullet.y >= 127 or bullet.dead then
        return false
    else 
        return true 
    end
end

function _bullet_draw(bullet)
    line(bullet.x, bullet.y, bullet.x, bullet.y +5, BULLET_COLOR)
end

function make_bullet(x)
    local bullet = {}

    bullet.dead = false
    bullet.x = x
    bullet.y = 20 - 7

    bullet.update = _bullet_update
    bullet.draw = _bullet_draw

    return bullet
end

function _bullet_mgr_update(bm, inputs)
    if inputs.btn_x
        and bm.scene.player 
        and #bm.bullets < BULLET_MAX_COUNT
        and t() > bm.shoot_after_t
        then
        sfx(5)
        bm.shoot_after_t = t() + BULLET_COOLDOWN
        local bullet = make_bullet(
            bm.scene.player.flip 
            and bm.scene.player.x 
            or bm.scene.player.x + 7
        )
        add(bm.bullets, bullet)
    end

    local dead_bullets = {}
    for bullet in all(bm.bullets) do
        alive = bullet:update()
        if not alive then add(dead_bullets, bullet) end
    end
    for bullet in all(dead_bullets) do
        del(bm.bullets, bullet)
    end
end

function _bullet_mgr_draw(bm)
    for bullet in all(bm.bullets) do
        bullet:draw()
    end
end

function make_bullet_mgr(scene)
    local bm = {}

    bm.scene = scene
    bm.bullets = {}
    bm.shoot_after_t = t()

    bm.update = _bullet_mgr_update
    bm.draw = _bullet_mgr_draw

    return bm
end