local M = {
    active_enemies = {}
}

function M.add_enemy(enemy_url)
    table.insert(M.active_enemies, enemy_url)
end

function M.remove_enemy(enemy_url)
    for i, url in ipairs(M.active_enemies) do
        if url == enemy_url then
            table.remove(M.active_enemies, i)
            break
        end
    end
end

function M.get_active_enemies()
    return M.active_enemies
end

return M
