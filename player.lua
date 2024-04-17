PLAYER_SPEED = 1
PLAYER_HEIGHT = 16-4

function _player_draw(player)
    spr(0, player.x, PLAYER_HEIGHT, 1, 1, player.flip)
    if player.bullet then player.bullet:draw() end
end

function _player_update(player, inputs)
    if inputs.left == true then
        player.flip = true
        player.x -= PLAYER_SPEED
    elseif inputs.right == true then
        player.flip = false
        player.x += PLAYER_SPEED
    end
    if player.x > 127 - 7 then player.x = 127 - 7 end
    if player.x < 0 then player.x = 0 end
    if inputs.btn_x and not player.bullet then
        sfx(5)
        player.bullet = make_bullet(player.flip and player.x or player.x + 7)
    end
    if player.bullet then player.bullet = player.bullet:update() end
end

function make_player()
    local player = {}

    player.flip = false
    player.x = 64 - 8
    player.y = PLAYER_HEIGHT

    player.update = _player_update
    player.draw = _player_draw

    return player
end