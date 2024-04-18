MONSTER_SPEED = 0.33
MONSTER_ACCEL = 1.2
MONSTER_SUMMON_DURATION = 1
MONSTER_CLIMB_DURATION = 0.75

MONSTER_FRAME_1 = 1
MONSTER_FRAME_2 = 17

MONSTER_MAX_MONSTERS = 200
MONSTER_MIN_SUMMON_CD = 0.25
MONSTER_MAX_SUMMON_CD = 1.5
MONSTER_MAX_SUMMON_CD_SCORE = 250

function _monster_update(monster)
    if monster.summoning then
        if (t() > monster.spawn_completes_at) then 
            monster.summoning = false
        else
            monster.y = lerp(108, 128, easeinelastic((monster.spawn_completes_at - t())/(monster.spawn_completes_at - monster.spawned_at)))
        end
    elseif monster.jumping then
        if (t() > monster.jump_completes_at) then
            monster.jumping = false
        else
            monster.y = lerp(monster.jump_end_y, monster.jump_start_y, easeinelastic((monster.jump_completes_at - t())/(monster.jump_completes_at - monster.jumped_at)))
        end
    else
        if t() % 0.25 == 0 then
            monster.frame = monster.frame == MONSTER_FRAME_1 and MONSTER_FRAME_2 or MONSTER_FRAME_1
        end

        monster.x += monster.flip and -monster.speed or monster.speed
        if monster.x > 127 - 8 then
            if monster.y > 20 then monster.jumping = true else return false end
            monster.x = 127 - 8
            monster.flip = not monster.flip
        end
        if monster.x < 1 then
            if monster.y > 20 then monster.jumping = true else return false end
            monster.x = 1
            monster.flip = not monster.flip
        end
        if monster.jumping then
            sfx(0)
            monster.speed *= MONSTER_ACCEL
            monster.jumped_at = t()
            monster.jump_completes_at = t() + MONSTER_CLIMB_DURATION
            monster.jump_start_y = monster.y
            monster.jump_end_y = monster.y - 16
        end
    end

    return true
end

function _monster_draw(monster)
    if monster.summoning then
        ovalfill(monster.x, 123, monster.x + 8, 127, 2)
        oval(monster.x, 123, monster.x + 8, 127, 8)
    end
    spr(monster.frame, monster.x, monster.y, 1, 1, monster.flip)
end

function make_monster()
    sfx(1)
    local monster = {}

    monster.x = flr(rnd(127 -8)) + 1
    monster.summoning = true
    monster.frame = MONSTER_FRAME_1
    monster.jumping = false
    monster.jumped_at = 0
    monster.jump_completes_at = 0
    monster.jump_start_y = 0
    monster.jump_end_y = 0
    monster.spawned_at = t()
    monster.spawn_completes_at = t() + MONSTER_SUMMON_DURATION
    monster.speed = MONSTER_SPEED
    monster.flip = rnd(2) > 1 and true or false
    monster.y = 299

    monster.update = _monster_update
    monster.draw = _monster_draw

    return monster
end

function _update_monster_mgr(mm)
    if mm.scene.player and t() > mm.spawn_after_t and #mm.monsters < MONSTER_MAX_MONSTERS then
        local delay = MONSTER_MIN_SUMMON_CD 
            + ((MONSTER_MAX_SUMMON_CD - MONSTER_MIN_SUMMON_CD) * (max(1 - (mm.scene.score/MONSTER_MAX_SUMMON_CD_SCORE), 0)))
        mm.spawn_after_t = t() + delay
        add(mm.monsters, make_monster())
    end

    local dead_monsters = {}
    for monster in all(mm.monsters) do
        local monster_is_alive = monster:update()
        if not monster_is_alive then
            add(dead_monsters, monster)
        end
    end
    for dead_monster in all(dead_monsters) do
        del(mm.monsters, dead_monster)
    end
end

function _draw_monster_mgr(mm)
    for monster in all(mm.monsters) do monster:draw() end
end

function _kill_monster_mgr(mm, monster)
    del(mm.monsters, monster)
end

function make_monster_mgr(scene)
    local monster_mgr = {}

    monster_mgr.monsters = {}
    monster_mgr.spawn_after_t = t()

    monster_mgr.scene = scene
    monster_mgr.update = _update_monster_mgr
    monster_mgr.draw = _draw_monster_mgr
    monster_mgr.kill = _kill_monster_mgr

    return monster_mgr
end