GRAVITY = 0.125
SPLASH_THROB_SPEED = 0.125

function _splash_get_random_radius()
    return flr(rnd(150) + 1) / 100
end

function _splash_update(splash)
    finished_particle_count = 0
    for particle in all (splash.particles) do
        particle.x = particle.x + particle.velocity_x
        particle.velocity_y += GRAVITY * rnd(2)
        particle.y = particle.y + particle.velocity_y
        if t() - particle.throb_timer_start > SPLASH_THROB_SPEED then
            particle.throb_timer_start = t()
            particle.radius = _splash_get_random_radius()
        end
        if particle.y > particle.floor then 
            finished_particle_count +=1
            particle.y = particle.floor
        end
    end
    if finished_particle_count == #splash.particles then splash.callback(splash) end
end

function _splash_draw(splash)
    for particle in all(splash.particles) do
        circfill(particle.x, particle.y, particle.radius, splash.color)
    end
end

function make_splash(x, y, color, callback)
    local splash = {
        color = color,
        callback = callback,
    }

    splash.particles = {}

    for i = 1, 100 do
        local velocity_x = (rnd(1) > 0.5 and -1 or 1) * rnd(2)
        local velocity_y = -rnd(3)
        local radius = _splash_get_random_radius()
        add(splash.particles, {
            x = x + 4,
            y = y + 4,
            velocity_x = velocity_x,
            velocity_y = velocity_y,
            radius = radius,
            throb_timer_start = t(),
            floor = 129
        })
    end

    splash.update = _splash_update
    splash.draw = _splash_draw

    return splash
end