local Player = {}

function Player:new(name, health, speed)
	local instance = {
		name = name or "Player",
		health = health or 100,
		speed = speed or 200,
		direction = vmath.vector3(1, 0, 0), -- Direccion inicial
	}
	setmetatable(instance, { __index = self })
	return instance
end

function Player:move(input)
	self.direction = input
	-- Lógica de movimiento
end

function Player:take_damage(amount)
	self.health = self.health - amount
	if self.health <= 0 then
		print("Player muerto")
	end
end

return Player
