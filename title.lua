function _update_title(scene, inputs)
    if btnp(🅾️) then
        change_scene(make_game_scene())
    end

    scene.player:update(inputs)
    scene.monster_mgr:update()
    scene.bullet_mgr:update(inputs)
    for juice in all(scene.juice) do
        juice:update()
    end

    for bullet in all(scene.bullet_mgr.bullets) do
        if not bullet.dead then
            local dead_monster = nil
            for monster in all(scene.monster_mgr.monsters) do
                if not dead_monster and collide_line_sprite(bullet, monster) then
                    if scene.player then scene.score += 1 end
                    dead_monster = monster
                end
            end
            if dead_monster then 
                local function clean_up(juice) del(scene.juice, juice) end
                add(scene.juice, make_splash(dead_monster.x, dead_monster.y, 2, clean_up))
                scene.monster_mgr:kill(dead_monster)
                bullet.dead = true
                add(scene.monster_mgr.monsters, make_monster(true))
            end
        end
    end
end

function _draw_title(scene)
    cls(0)
    rectfill(0, 0, 127, 30, 12)

    for j=0, 15 do
        spr(14, j * 8, 30)
        spr(15, j * 8, 116)
    end

    fancy_text({
        x = 2,
        y = 2,
        text = "heck breaks loose!",
        big = true,
        letter_width = 7,
        outline_color = 5,
        text_colors = {8},
    })
    print("ludum dare 55 - \"summoning\"", 10, 14, 7)

    print("HI SCORE: " .. dget(0), 70, 39, 7)

    print("⬅️ ➡️ move", 2, 42, 8)
    print("❎ magic missile", 2, 50)
    
    print("shoot monsters!", 64, 66)
    print("avoid fireballs!", 64, 66+8)
    
    fancy_text({
        x = 34,
        y = 96,
        text = "press 🅾️  to start",
        big = false,
        bubble_depth = 1,
        background_color = 8,
        text_colors = {7},
    })

    print("cheesepencil.itch.io", 24, 122, 8)

    scene.player:draw()
    scene.monster_mgr:draw()
    scene.bullet_mgr:draw()
    for juice in all(scene.juice) do
        juice:draw()
    end
end

function make_title_scene()
    local scene = {}

    scene.juice = {}
    scene.score = 0
    scene.player = make_player(scene, 30-8)
    scene.bullet_mgr = make_bullet_mgr(scene)
    scene.monster_mgr = make_monster_mgr(scene, true)
    add(scene.monster_mgr.monsters, make_monster(true))

    scene.update = _update_title
    scene.draw = _draw_title

    return scene
end