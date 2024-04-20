scene = {}

function change_scene(new_scene)
    scene = new_scene
end

function _init()
    cartdata("cp_ld55_0")
    scene = make_title_scene()
end

function _update60()
    -- input
    local inputs = {
        left = btn(⬅️),
        right = btn(➡️),
        btn_x = btn(❎),
        btn_o = btn(🅾️),
    }

    scene:update(inputs)
end

function change_scene(new_scene)
    scene = new_scene
end

function _draw()
    scene:draw()
end