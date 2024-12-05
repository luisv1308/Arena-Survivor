local M = {}

function M.play_animation(self, animation)
    -- Solo cambia la animación si es diferente de la actual
    if self.current_animation ~= animation then
        self.current_animation = animation
        sprite.play_flipbook("#sprite", animation, complete_function(animation))
    end
    
end

function complete_function(animation)
    msg.post("#", "complete_animation", { id = hash(animation) })
    
end

return M