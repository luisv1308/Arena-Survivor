local Enemy = {}

function Enemy:new(name, health, speed)
    --print(id)
    local instance = {
        name = name or "Unnamed Enemy",
        health = health or 20,
        speed = speed or 50,
        is_alive = true,
    }
    setmetatable(instance, { __index = self })
    return instance
end

function Enemy:take_damage(amount)
    print(self.name .. " takes " .. amount .. " damage!xxxxxxxxxxxxxxxxxxxxxxxxxxccccccccccccccccccc")
    self.health = self.health - amount
    if self.health <= 0 then
        self.is_alive = false
        print(self.name .. " has been defeated!")
        msg.post("/wave_manager", "enemy_destroyed")
        msg.post("/wave_manager", "remove_enemy", { enemy_url = self.url })
        go.delete()

    else
        print(self.name .. " took " .. amount .. " damage! Remaining health: " .. self.health)
    end
end

function Enemy:move(direction)
    print(self.name .. " moves in direction: " .. tostring(direction) .. " at speed: " .. self.speed)
    -- Aquí puedes agregar lógica para mover al enemigo en el juego
end

return Enemy
