local StateMachine = {}

function StateMachine.new()
    local sm = {
        current_state = nil,
        previous_state = nil,
        states = {}
    }

    -- Obtener el estado actual
    function sm:get_state()
        return self.current_state
    end

    -- Obtener el estado previo (opcional)
    function sm:get_previous_state()
        return self.previous_state
    end
    
    function sm:add_state(name, state)
        self.states[name] = state
    end

    function sm:set_state(name)
        if self.current_state and self.states[self.current_state].exit then
            self.states[self.current_state].exit()
        end

        self.current_state = name

        if self.states[self.current_state].enter then
            self.states[self.current_state].enter()
        end
    end

    function sm:update(dt)
        if self.current_state and self.states[self.current_state].update then
            self.states[self.current_state].update(dt)
        end
    end

    return sm
end

return StateMachine
