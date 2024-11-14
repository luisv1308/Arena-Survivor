local M = {}

function M.play_animation(self, animation)
    -- Solo cambia la animación si es diferente de la actual
    if self.current_animation ~= animation then
        msg.post("#sprite", "play_animation", { id = hash(animation) })
        self.current_animation = animation
    end
end

return M