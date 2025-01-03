local Player = require "main.objects.player.Player"

local Barbarian = Player:new()


function Barbarian:new()
	local instance = Player.new(self, "Barbarian", 20, 70, 1)
	setmetatable(instance, { __index = self })
	instance.special_attack = "Whirlwind"
	return instance
end

function Barbarian:use_special()
	print("Usando ataque especial: " .. self.special_attack)
end

return Barbarian
