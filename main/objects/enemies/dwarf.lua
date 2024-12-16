local Enemy = require "main/objects/enemies/enemy"

local Dwarf = Enemy:new()

function Dwarf:new()
    local instance = Enemy.new(self, "Dwarf", 150, 30) -- Nombre, salud, velocidad
    setmetatable(instance, { __index = self })
    return instance
end

function Dwarf:attack()
    print(self.name .. " attacks with a hammer!")
end

return Dwarf
