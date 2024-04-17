FIREBALL_SPEED = 1
FIREBALL_ANIM_SPEED = 0.125
FIREBALL_SPAWN_MIN_T = 1
FIREBALL_SPAWN_MAX_T = 4

function _update_fireball(fireball)
    if fireball.y < -8 then return false end

    if t() > fireball.flip_after_t then 
        fireball.flip_after_t = t() + FIREBALL_ANIM_SPEED
        fireball.flip = not fireball.flip
    end

    fireball.y -= FIREBALL_SPEED
    return true
end

function make_fireball(x)
    local fireball = {}

    fireball.x = x
    fireball.y = 128
    fireball.flip_after_t = t() + FIREBALL_ANIM_SPEED
    fireball.flip = false

    fireball.update = _update_fireball
    fireball.draw = function(f) 
        spr(2, fireball.x, fireball.y, 1, 1, fireball.flip)
    end

    sfx(3)
    return fireball
end

function _fireball_mgr_update(fbm)
    local dead_fireballs = {}
    for fireball in all(fbm.fireballs) do
        local fireball_is_alive = fireball:update()
        if not fireball_is_alive then add(dead_fireballs, fireball) end
    end
    for dead_fireball in all(dead_fireballs) do
        del(fbm.scene.fireballs, dead_fireball)
    end

    if fbm.scene.player and t() > fbm.spawn_after_t then
        fbm.spawn_after_t = t() + rnd(4) + 1
        add(fbm.fireballs, make_fireball(scene.player.x))
    end
end

function _fireball_mgr_draw(fbm)
    for fireball in all(fbm.fireballs) do
        fireball:draw()
    end
end

function _make_fireball_mgr(scene)
    local fireball_mgr = {}

    fireball_mgr.fireballs = {}
    fireball_mgr.spawn_after_t = 0

    fireball_mgr.scene = scene
    fireball_mgr.update = _fireball_mgr_update
    fireball_mgr.draw = _fireball_mgr_draw

    return fireball_mgr
end