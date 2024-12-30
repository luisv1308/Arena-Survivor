local M = {}

local Animation = require "main/objects/player/Animation"

-- Attack with 6 animations and cooldown
function M.attack(self, properties)
    if not properties.attacking then
        -- Check face direction and play attack animation
        if self.dir.y > 0 and self.player_face_dir.x > 0 then
            Animation.play_animation(self, "attack_up_right")
        elseif self.dir.y > 0 and self.player_face_dir.x < 0 then
            Animation.play_animation(self, "attack_up_left")
        elseif self.dir.y < 0 and self.player_face_dir.x > 0 then
            Animation.play_animation(self, "attack_down_right")
        elseif self.dir.y < 0 and self.player_face_dir.x < 0 then
            Animation.play_animation(self, "attack_down_left")
        elseif self.dir.x > 0 then
            Animation.play_animation(self, "attack_right")
        elseif self.dir.x < 0 then
            Animation.play_animation(self, "attack_left")
        end

        properties.attacking = true
        properties.last_attack_time = socket.gettime()

        -- Send update to parent player
        --[[ local parent = go.get_id("Player")
        msg.post(parent, "attack_cooldown", {
            attack_cooldown = properties.attack_cooldown,
            attacking = properties.attacking,
            last_attack_time = properties.last_attack_time
        }) ]]
    end
end

-- Handle damage when hit by an enemy or obstacle
function M.take_damage(self, damage, properties)
    if not properties.invulnerable then
        self.health = self.health - damage
        properties.invulnerable = true
        properties.last_damage_time = socket.gettime()

        if self.health <= 0 then
            self.state = "dead"
            Animation.play_animation(self, "dead")
        else
            self.state = "damaged"
            Animation.play_animation(self, "damage")
        end
    end
end

-- Cooldown for attack
function M.attack_cooldown(properties, dt)
    local current_time = socket.gettime()
    if properties.attacking and current_time - properties.last_attack_time >= properties.attack_cooldown then
        properties.attacking = false
        properties.last_attack_time = current_time

        -- Send update to parent player
        local parent = go.get_id("Player")
        msg.post(parent, "attack_cooldown", {
            attack_cooldown = properties.attack_cooldown,
            attacking = properties.attacking,
            last_attack_time = properties.last_attack_time
        })
    end
end

-- Cooldown for damage invulnerability
function M.damage_cooldown(properties, dt)
    if properties.invulnerable and socket.gettime() - properties.last_damage_time >= properties.damage_cooldown then
        properties.invulnerable = false
    end
end

-- Handle collision detection for attacks and damage
function M.handle_collision(self, message_id, message, properties)
    if message_id == hash("collision_response") then
        local other_id = message.other_id
        local group = message.group

        -- Check if the collision is with an enemy or a damage source
        if group == hash("enemy") and properties.attacking then
            -- Send damage to the enemy
            msg.post(other_id, "take_damage", { damage = properties.attack_damage })
        elseif group == hash("enemy_attack") then
            -- Take damage from the enemy attack
            M.take_damage(self, message.damage or 1, properties)
        end
    end
end

return M
