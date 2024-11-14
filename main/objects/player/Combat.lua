local M = {}

-- Ejemplo de recibir daño con invulnerabilidad y cooldown
function M.take_damage(self, damage)
    if not self.invulnerable then
        self.health = self.health - damage
        self.invulnerable = true
        self.last_damage_time = socket.gettime()

        if self.health <= 0 then
            self.state = "dead"
            Animation.play_animation(self, "dead")
        else
            self.state = "damaged"
            Animation.play_animation(self, "damage")
        end
    end
end

function M.cooldown(self, dt)
    -- Ejemplo de gestión de estado "damage cooldown"
    if self.invulnerable and socket.gettime() - self.last_damage_time >= self.damage_cooldown then
        self.invulnerable = false
    end
end

return M