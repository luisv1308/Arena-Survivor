local M = {}

local Animation = require "main/objects/player/Animation"

-- attack with 6 animations and cooldown
function M.attack(self, properties)
    if not properties.attacking  then
        --check face direction and play attack animation
        -- Cambiar la animación de acuerdo con la dirección y checa si va izquierda o derecha
        if self.dir.y > 0 and self.player_face_dir.x > 0 then
            --print("walk_up_right")
            Animation.play_animation(self, "attack_up_right")
        elseif self.dir.y > 0 and self.player_face_dir.x < 0 then
            --print("walk_up_left")
            Animation.play_animation(self, "attack_up_left")
        elseif self.dir.y < 0 and self.player_face_dir.x > 0 then
            --print("walk_down_right")
            Animation.play_animation(self, "attack_down_right")
        elseif self.dir.y < 0 and self.player_face_dir.x < 0 then
            --print("walk_down_left")
            Animation.play_animation(self, "attack_down_left")
        elseif self.dir.x > 0 then
            --print("walk_right")
            Animation.play_animation(self, "attack_right")
        elseif self.dir.x < 0 then
            --print("walk_left")
            Animation.play_animation(self, "attack_left")
        end

        properties.attacking = true 
        properties.last_attack_time = socket.gettime()  -- Guardar el tiempo de la animación de ataques

        --send update to parent player_id        
        local parent = go.get_id("Player")
        msg.post(parent, "attack_cooldown", { attack_cooldown = properties.attack_cooldown, attacking = properties.attacking, last_attack_time = properties.last_attack_time })

    end
end

function M.take_damage(self, damage, properties)
    if not properties.invulnerable then
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

function M.attack_cooldown(properties, dt)
    local current_time = socket.gettime()
    -- Ejemplo de gestión de estado "attack cooldown"
    if properties.attacking and current_time - properties.last_attack_time >= properties.attack_cooldown then
        properties.attacking = false
        properties.last_attack_time = current_time
        --send update to parent player  
        local parent = go.get_id("Player")
        msg.post(parent, "attack_cooldown", { attack_cooldown = properties.attack_cooldown, attacking = properties.attacking, last_attack_time = properties.last_attack_time })
    end
end

function M.damage_cooldown(properties, dt)
    -- Ejemplo de gestión de estado "damage cooldown"
    if properties.invulnerable and socket.gettime() - properties.last_damage_time >= properties.damage_cooldown then
        properties.invulnerable = false
    end
end

return M