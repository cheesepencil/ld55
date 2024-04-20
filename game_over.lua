GO_Y_START = 128
GO_Y_END = 48
GO_ANIM_DUR = 1

function _game_over_update(go)
    if t() > go.anim_end then
        if btnp(🅾️) then
            change_scene(make_game_scene())
        elseif btnp(❎) then
            change_scene(make_title_scene())
        end
    end
end

function _game_over_draw(go)
    local t = t() > go.anim_end and 1 or (1 - (go.anim_end - t())/(go.anim_end - go.anim_start))

    local y = lerp(go.start_y, go.end_y, t)

    fancy_text({
        x = 34,
        y = y,
        text = "you died",
        big = true,
        outline_color = 5,
        text_colors = {8},
    })
    print("game over!", 46, y + 12, 7)
    
    print("🅾️  try again", 24, y + 36, 7)
    print("❎  return to title", 24, y + 36 + 8, 7)
end

function make_game_over()
    local go = {}

    go.start_y = GO_Y_START
    go.end_y = GO_Y_END
    go.anim_start = t()
    go.anim_end = t() + GO_ANIM_DUR

    go.update = _game_over_update
    go.draw = _game_over_draw

    return go
end