local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Components = require(ReplicatedStorage.Shared.Components)

return function(world)
	for id, nami, instance in world:query(Components.Nami, Components.Instance) do
		print("found nami at", id, "with height", nami.Height, "and instance", instance.Instance)
	end
end
