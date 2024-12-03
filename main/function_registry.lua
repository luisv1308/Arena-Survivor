-- function_registry.lua
local M = {}

M.functions = {}

function M.register(player_id, function_name, func)
    M.functions[player_id] = M.functions[player_id] or {}
    M.functions[player_id][function_name] = func
end

function M.get(player_id, function_name)
    if M.functions[player_id] then
        return M.functions[player_id][function_name]
    end
    return nil
end

return M
