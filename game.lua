GAME_FLOOR_COLOR = 2
GAME_WALL_COLOR = 5

function _game_scene_init(scene)
    scene.score = 0

    scene.player = make_player(scene)
    scene.monster_mgr = make_monster_mgr(scene)
    scene.fireball_mgr = make_fireball_mgr(scene)
end

function _game_scene_update(scene, inputs, restart)
    if scene.player then scene.player:update(inputs) end

    if btnp(🅾️) then
        restart()
    end

    scene.fireball_mgr:update()
    scene.monster_mgr:update()

    -- collisions!
    for fireball in all(scene.fireball_mgr.fireballs) do
        if scene.player and collide_8x8(scene.player, fireball) then
            scene.player:kill()
        end
    end
    for monster in all(scene.monster_mgr.monsters) do
        if scene.player and collide_8x8(monster, scene.player) then 
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

    scene.monster_mgr:draw()
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