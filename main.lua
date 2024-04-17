scene = {}

function change_scene(new_scene)
    scene = new_scene
end

function _init()
    scene = make_game_scene()
end

function _update60()
    -- input
    inputs = {
        left = btn(⬅️),
        right = btn(➡️),
        btn_x = btn(❎),
        btn_o = btn(🅾️),
    }

    scene:update(inputs, restart)
end

function restart()
    scene = make_game_scene()
end

function _draw()
    scene:draw()
end