function _game_scene_init(scene)
    scene.score = 0

    scene.juice = {}
    scene.player = make_player(scene)
    scene.bullet_mgr = make_bullet_mgr(scene)
    scene.monster_mgr = make_monster_mgr(scene)
    scene.fireball_mgr = make_fireball_mgr(scene)
    scene.game_over = nil
end

function _game_scene_update(scene, inputs)
    if scene.player then scene.player:update(inputs) end

    scene.fireball_mgr:update()
    scene.monster_mgr:update()
    scene.bullet_mgr:update(inputs)

    -- collisions!
    for fireball in all(scene.fireball_mgr.fireballs) do
        if scene.player and collide_8x8(scene.player, fireball) then
            local function clean_up(juice) del(scene.juice, juice) end
            add(scene.juice, make_splash(scene.player.x, scene.player.y, 0, clean_up))
            scene.player:kill()
            scene.game_over = make_game_over()
        end
    end
    for monster in all(scene.monster_mgr.monsters) do
        if scene.player and collide_8x8(monster, scene.player) then
            local function clean_up(juice) del(scene.juice, juice) end
            add(scene.juice, make_splash(scene.player.x, scene.player.y, 8, clean_up))
            scene.player:kill()
            scene.game_over = make_game_over()
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
                local function clean_up(juice) del(scene.juice, juice) end
                add(scene.juice, make_splash(dead_monster.x, dead_monster.y, 2, clean_up))
                scene.monster_mgr:kill(dead_monster)
                bullet.dead = true
            end
        end
    end
    for juice in all(scene.juice) do
        juice:update()
    end
    if scene.game_over then
        scene.game_over:update()
    end
end

function _game_scene_draw(scene)
    cls(0)
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

    print("HI SCORE: " .. dget(0), 64, 1, 7)
    print("SCORE: " .. scene.score, 1, 1, 7)

    for juice in all(scene.juice) do
        juice:draw()
    end

    if scene.game_over then
        scene.game_over:draw()
    end
end

function make_game_scene()
    local scene = {}

    scene.init = _game_scene_init
    scene.update = _game_scene_update
    scene.draw = _game_scene_draw
    
    scene:init()    
    return scene
end