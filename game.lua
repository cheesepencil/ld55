GAME_FLOOR_COLOR = 2
GAME_WALL_COLOR = 5

function _game_scene_init()
    return
end

function _game_scene_update(scene, inputs, restart)
    if scene.player then scene.player:update(inputs) end

    if btnp(🅾️) then
        restart()
    end

    if t() % 1 == 0 and scene.player and flr(rnd(2)) > 0 then
        add(scene.monsters, make_monster())
    end

    if t() % 1 == 0 and scene.player and flr(rnd(2)) > 0 then
        sfx(3)
        add(scene.fireballs, make_fireball(scene.player.x))
    end

    local dead_monsters = {}
    for monster in all(scene.monsters) do
        local monster_is_alive = monster:update(scene)
        if not monster_is_alive then
            add(dead_monsters, monster)
        elseif (scene.player) then
            if _collide_monster_and_player(monster, scene.player) then 
                sfx(2)
                scene.player = nil
            end
        end
    end
    for dead_monster in all(dead_monsters) do
        del(scene.monsters, dead_monster)
        if scene.player then add(scene.monsters, make_monster()) end
    end

    local dead_fireballs = {}
    for fireball in all(scene.fireballs) do
        local fireball_is_alive = fireball:update(scene)
        if not fireball_is_alive then
            add(dead_fireballs, fireball)
        elseif (scene.player) then
            if _collide_monster_and_player(fireball, scene.player) then 
                sfx(2)
                scene.player = nil
            end
        end
    end
    for dead_fireball in all(dead_fireballs) do
        del(scene.fireballs, dead_fireball)
    end
end

function _game_scene_draw(scene)
    rectfill(0, 0, 127, 127, 0)
    line(0,20,0,127, GAME_WALL_COLOR)
    line(127,20,127,127, GAME_WALL_COLOR)
    for i=20, 128, 16 do
        line(0, i, 127, i, GAME_FLOOR_COLOR)
    end
    
    if scene.player then scene.player:draw() end
    
    for monster in all(scene.monsters) do
        monster:draw()
    end

    for fireball in all(scene.fireballs) do
        fireball:draw()
    end

    print("score: " .. scene.score, 1, 1, 2)
end

function make_game_scene()
    local scene = {}

    scene.score = 0

    scene.player = make_player()
    scene.monsters = {}
    scene.fireballs = {}
    add(scene.monsters, make_monster())
    
    scene.update = _game_scene_update
    scene.draw = _game_scene_draw

    _game_scene_init()

    return scene
end

function _collide_monster_and_player(monster, player)
    local aLeft = monster.x
    local aTop = monster.y
    local aRigth = monster.x + 8
    local aBottom = monster.y + 8

    local bLeft = player.x
    local bTop = player.y
    local bRigth = player.x + 8
    local bBottom = player.y + 8

    if (aTop > bBottom)  return false 
    if (bTop > aBottom)  return false 
    if (aLeft > bRigth)  return false 
    if (bLeft > aRigth)  return false 

    return true
end