local M = {}

-- Reproduce una animación si no es la actual
function M.play_animation(self, animation, url)
    --checar si url es null
    url = url or "#sprite"
    if self.current_animation ~= animation then
        self.current_animation = animation
        sprite.play_flipbook(url, animation, function()
            M.complete_animation(animation)
        end)
    end
end

-- Lógica cuando una animación se completa
function M.complete_animation(animation)
    --msg.post("#", "complete_animation", { id = hash(animation) })
end

-- Cambia el sprite objetivo dinámicamente (útil si tienes múltiples sprites)
function M.set_sprite_target(self, sprite_url)
    self.sprite_target = sprite_url or "#sprite"
end

-- Devuelve la animación actual (útil para depuración o lógica condicional)
function M.get_current_animation(self)
    return self.current_animation
end

function M.stop_animation(self)
    self.current_animation = nil
end

return M
