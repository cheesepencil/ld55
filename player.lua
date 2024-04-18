PLAYER_SPEED = 1
PLAYER_HEIGHT = 16-4
PLAYER_ANIM_SPEED = 0.125

function _player_kill(player)
    if player.scene.score > dget(0) then dset(0, player.scene.score) end
    sfx(2)
    player.scene.player = nil
end

function _player_draw(player)
    spr(player.frame, player.x, PLAYER_HEIGHT, 1, 1, player.flip)
end

function _player_update(player)
    local moving = false
    if inputs.left == true then
        moving = true
        player.flip = true
        player.x -= PLAYER_SPEED
    elseif inputs.right == true then
        moving = true
        player.flip = false
        player.x += PLAYER_SPEED
    end

    if moving and t() > player.frame_change_after then
        player.frame = player.frame == 0 and 16 or 0
        player.frame_change_after = t() + PLAYER_ANIM_SPEED
    end

    if player.x > 127 - 7 then player.x = 127 - 7 end
    if player.x < 0 then player.x = 0 end
end

function make_player(scene)
    local player = {}

    player.scene = scene
    player.frame = 0
    player.frame_change_after = t()
    player.flip = false
    player.x = 64 - 8
    player.y = PLAYER_HEIGHT

    player.update = _player_update
    player.draw = _player_draw
    player.kill = _player_kill

    return player
end