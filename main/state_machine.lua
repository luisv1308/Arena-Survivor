local StateMachine = {}

function StateMachine.new()
    local instance = {
        current_state = nil,
        previous_state = nil,
        states = {}
    }
    setmetatable(instance, { __index = StateMachine })
    return instance
end

function StateMachine:get_state()
    return self.current_state
end

-- Obtener el estado previo (opcional)
function StateMachine:get_previous_state()
    return self.previous_state
end

function StateMachine:add_state(name, state)
    self.states[name] = state
end

function StateMachine:set_state(name, ...)
    if self.current_state and self.states[self.current_state].exit then
        self.states[self.current_state].exit()
    end
    self.current_state = name
    if self.states[name].enter then
        self.states[name].enter(...)
    end
end

function StateMachine:update(dt)
    if self.current_state and self.states[self.current_state].update then
        self.states[self.current_state].update(dt)
    end
end

function StateMachine:exit_current_state()
    if self.current_state and self.states[self.current_state].exit then
        self.states[self.current_state].exit()
    end
    self.previous_state = self.current_state
    self.current_state = nil
end

return StateMachine
