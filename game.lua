function _game_scene_init(scene)
    scene.score = 0

    scene.player = make_player(scene)
    scene.bullet_mgr = make_bullet_mgr(scene)
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
    scene.bullet_mgr:update(inputs)

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
    for bullet in all(scene.bullet_mgr.bullets) do
        if not bullet.dead then
            local dead_monster = nil
            for monster in all(scene.monster_mgr.monsters) do
                if not dead_monster and collide_line_sprite(bullet, monster) then
                    if scene.player then scene.score += 1 end
                    dead_monster = monster
                    -- add(scene.monster_mgr.monsters, make_monster())
                end
            end
            if dead_monster then 
                scene.monster_mgr:kill(dead_monster)
                bullet.dead = true
            end
        end
    end
end

function _game_scene_draw(scene)
    rectfill(0, 0, 127, 127, 0)
    rectfill(0, 0, 127, 20, 12)
    
    for i=20, 128, 16 do
        for j=0, 15 do
            if i == 20 then
                spr(14, j * 8, i)
            else
                spr(15, j * 8, i)
            end
        end
    end
    
    if scene.player then scene.player:draw() end

    scene.monster_mgr:draw()
    scene.fireball_mgr:draw()
    scene.bullet_mgr:draw()

    print("best: " .. dget(0), 64, 1, 7)
    print("score: " .. scene.score, 1, 1, 7)
end

function make_game_scene()
    local scene = {}

    scene.init = _game_scene_init
    scene.update = _game_scene_update
    scene.draw = _game_scene_draw
    
    scene:init()    
    return scene
end