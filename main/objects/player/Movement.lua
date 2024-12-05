local M = {}

local input_left = hash("left")
local input_right = hash("right")
local input_up = hash("up")
local input_down = hash("down")

function M.move(self, dt)
    if self.moving  then
        local pos = go.get_position()
        pos = pos + self.dir * self.base_speed  * dt  -- Mueve al jugador en la dirección especificada
        go.set_position(pos)
        --print("pos", self.dir.x, self.dir.y)
    end
end

function M.handle_input(self, action_id, action, Animation)
    print("inside handle_input")
    -- Controlar direcciones de movimiento
    if action_id == input_left then
        if action.pressed then
			self.input.x = -1
            self.inputs_released.left = false
            self.player_face_dir.x = -1
        end
		if action.released then
			if not self.inputs_released.right then
                self.input.x = 1
            else
                self.input.x = 0
            end
            self.inputs_released.left = true
		end
	elseif action_id == input_right then
		if action.pressed then
			self.input.x = 1
            self.inputs_released.right = false
            self.player_face_dir.x = 1
        end
		if action.released then
			if not self.inputs_released.left then
                self.input.x = -1
            else
                self.input.x = 0
            end
            self.inputs_released.right = true
		end
	elseif action_id == input_up then
        if action.pressed then
            self.input.y = 1
            self.inputs_released.up = false
        end
        if action.released then
            if not self.inputs_released.down then
                self.input.y = -1
            else
                self.input.y = 0
            end
            self.inputs_released.up = true
        end
    elseif action_id == input_down then
        if action.pressed then
            self.input.y = -1
            self.inputs_released.down = false
        end
        if action.released then
            if not self.inputs_released.up then
                self.input.y = 1
            else
                self.input.y = 0
            end
            self.inputs_released.down = true
        end
	end
    -- Si hay movimiento, cambiar la dirección y la animación
    local size_vector = vmath.length(self.input)
    if size_vector > 0 then
        self.moving = true
        self.dir = vmath.normalize(self.input)  -- Normalizamos el vector de dirección

        -- Cambiar la animación de acuerdo con la dirección y checa si va izquierda o derecha
        if self.dir.y > 0 and self.player_face_dir.x > 0 then
            --print("walk_up_right")
            Animation.play_animation(self, "walk_up_right")
        elseif self.dir.y > 0 and self.player_face_dir.x < 0 then
            --print("walk_up_left")
            Animation.play_animation(self, "walk_up_left")
        elseif self.dir.y < 0 and self.player_face_dir.x > 0 then
            --print("walk_down_right")
            Animation.play_animation(self, "walk_down_right")
        elseif self.dir.y < 0 and self.player_face_dir.x < 0 then
            --print("walk_down_left")
            Animation.play_animation(self, "walk_down_left")
        elseif self.dir.x > 0 then
            --print("walk_right")
            Animation.play_animation(self, "walk_right")
        elseif self.dir.x < 0 then
            --print("walk_left")
            Animation.play_animation(self, "walk_left")
        end
    else
        self.moving = false
        --Send message to change state to idle 
        msg.post("#", "change_state", { id = "idle" })
        -- Si esta viendo a la derecha, poner la animación en idle normal y si esta viendo a la izquierda, poner la animación en idle mirando a la izquierda
        
    end    -- Controlar direcciones de movimiento
end

function M.set_all_movement_properties_to_zero(self)
    self.moving = false
    self.dir = vmath.vector3(0, 0, 0)
    self.player_face_dir = vmath.vector3(0, 0, 0)
    self.inputs_released = { up = true, down = true, left = true, right = true }
end

return M