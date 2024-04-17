GAME_FLOOR_COLOR = 2
GAME_WALL_COLOR = 5

function _game_scene_init(scene)
    scene.score = 0

    scene.player = make_player(scene)
    scene.monsters = {}
    scene.fireball_mgr = _make_fireball_mgr(scene)
    add(scene.monsters, make_monster())
end

function _game_scene_update(scene, inputs, restart)
    if scene.player then scene.player:update(inputs) end

    if btnp(🅾️) then
        restart()
    end

    if t() % 1 == 0 and scene.player and flr(rnd(2)) > 0 then
        add(scene.monsters, make_monster())
    end

    local dead_monsters = {}
    for monster in all(scene.monsters) do
        local monster_is_alive = monster:update(scene)
        if not monster_is_alive then
            add(dead_monsters, monster)
        elseif (scene.player) then
            if _collide_8x8(monster, scene.player) then 
                sfx(2)
                scene.player = nil
            end
        end
    end
    for dead_monster in all(dead_monsters) do
        del(scene.monsters, dead_monster)
        if scene.player then add(scene.monsters, make_monster()) end
    end

    scene.fireball_mgr:update()

    -- collisions!
    for fireball in all(scene.fireball_mgr.fireballs) do
        if scene.player and _collide_8x8(scene.player, fireball) then
            scene.player:kill()
        end
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

    scene.fireball_mgr:draw()

    print("score: " .. scene.score, 1, 1, 2)
end

function make_game_scene()
    local scene = {}

    scene.init = _game_scene_init
    scene.update = _game_scene_update
    scene.draw = _game_scene_draw
    
    scene:init()    
    return scene
end