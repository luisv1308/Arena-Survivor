local Enemy = require "main/objects/enemies/enemy"

local Goblin = Enemy:new()

function Goblin:new()
    local instance = Enemy.new(self, "Goblin", 20, 30) -- Nombre, salud, velocidad
    setmetatable(instance, { __index = self })
    return instance
end

function Goblin:attack()
    print(self.name .. " attacks with a dagger!")
end

return Goblin
