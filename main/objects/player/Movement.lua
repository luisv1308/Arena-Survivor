local M = {}

-- Constantes para los inputs
local input_left = hash("left")
local input_right = hash("right")
local input_up = hash("up")
local input_down = hash("down")

-- Mueve al jugador basado en su dirección y velocidad, verificando colisiones
function M.move(self, dt)
    if self.moving then
        local pos = go.get_position()
        local new_pos = pos + self.dir * self.base_speed * dt
        -- Verificar colisión antes de mover
        local result = physics.raycast(pos, new_pos, { collision_group = hash("walls") })
        if not result then
            go.set_position(new_pos) -- Solo mover si no hay colisión
        else
            print("Colisión detectada con:", result.id)
            msg.post("#", "collision_detected", { id = result.id })
        end
    end
end

-- Maneja el input del jugador y actualiza las animaciones
function M.handle_input(self, action_id, action, Animation)
    local input_changed = false

    -- Controla las direcciones de movimiento
    if action_id == input_left then
        if action.pressed then
            self.input.x = -1
            self.inputs_released.left = false
            self.player_face_dir.x = -1
            input_changed = true
        elseif action.released then
            self.input.x = self.inputs_released.right and 0 or 1
            self.inputs_released.left = true
            input_changed = true
        end
    elseif action_id == input_right then
        if action.pressed then
            self.input.x = 1
            self.inputs_released.right = false
            self.player_face_dir.x = 1
            input_changed = true
        elseif action.released then
            self.input.x = self.inputs_released.left and 0 or -1
            self.inputs_released.right = true
            input_changed = true
        end
    elseif action_id == input_up then
        if action.pressed then
            self.input.y = 1
            self.inputs_released.up = false
            input_changed = true
        elseif action.released then
            self.input.y = self.inputs_released.down and 0 or -1
            self.inputs_released.up = true
            input_changed = true
        end
    elseif action_id == input_down then
        if action.pressed then
            self.input.y = -1
            self.inputs_released.down = false
            input_changed = true
        elseif action.released then
            self.input.y = self.inputs_released.up and 0 or 1
            self.inputs_released.down = true
            input_changed = true
        end
    end

    -- Si el input cambió, actualizamos el estado de movimiento y animación
    if input_changed then
        local size_vector = vmath.length(self.input)
        if size_vector > 0 then
            self.moving = true
            self.dir = vmath.normalize(self.input)

            -- Cambiar animaciones basadas en la dirección
            if self.dir.y > 0 then
                if self.player_face_dir.x > 0 then
                    Animation.play_animation(self, "walk_up_right")
                else
                    Animation.play_animation(self, "walk_up_left")
                end
            elseif self.dir.y < 0 then
                if self.player_face_dir.x > 0 then
                    Animation.play_animation(self, "walk_down_right")
                else
                    Animation.play_animation(self, "walk_down_left")
                end
            elseif self.dir.x > 0 then
                Animation.play_animation(self, "walk_right")
            elseif self.dir.x < 0 then
                Animation.play_animation(self, "walk_left")
            end
        else
            self.moving = false
            msg.post("#", "change_state", { id = "idle" })
        end
    end
end

-- Reinicia todas las propiedades de movimiento
function M.set_all_movement_properties_to_zero(self)
    self.moving = false
    self.dir = vmath.vector3(0, 0, 0)
    self.player_face_dir = vmath.vector3(0, 0, 0)
    self.input = vmath.vector3(0, 0, 0)
    self.inputs_released = { up = true, down = true, left = true, right = true }
end

return M
