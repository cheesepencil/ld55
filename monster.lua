MONSTER_SPEED = 0.33
MONSTER_ACCEL = 1.2
MONSTER_SUMMON_DURATION = 1
MONSTER_CLIMB_DURATION = 0.75

MONSTER_FRAME_1 = 1
MONSTER_FRAME_2 = 17

function _monster_update(monster, scene)
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

    if scene.player and scene.player.bullet and not scene.player.bullet.killed then
        for by = scene.player.bullet.y, scene.player.bullet.y + 5 do
            if scene.player.bullet.x >= monster.x 
            and scene.player.bullet.x <= monster.x + 7
            and by >= monster.y
            and by <= monster.y + 7 then
                scene.score += 1
                scene.player.bullet.killed = true
                sfx(4)
                return false
            end
        end
    end

    return true
end

function _monster_draw(monster)
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

function easeinelastic(t)
	if(t==0) return 0
	return 2^(10*t-10)*cos(2*t-2)
end

function lerp(a,b,t)
	return a+(b-a)*t
end