local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Components = require(ReplicatedStorage.Shared.Components)

local function SetModelHeight(nami: Model, height: number)
	local legs = nami.Legs
	local legsPositionY = (height / 2)

	local currentSize = legs.Size

	legs.Size = Vector3.new(currentSize.X, height, currentSize.Z)
	legs.CFrame = CFrame.new(legs.Position.X, legsPositionY, legs.Position.Z) * legs.CFrame.Rotation

	local rootPart = nami.HumanoidRootPart
	rootPart.CFrame = legs.CFrame * CFrame.new(0, (rootPart.Size.Y / 2) + (legs.Size.Y / 2) - 0.3, 0)
end

return function(world)
	for id, nami, instance in world:query(Components.Nami, Components.Instance) do
		if nami.Height == instance.Instance:GetAttribute("Height") then
			continue
		end

		world:insert(
			id,
			nami:patch({
				Height = instance.Instance:GetAttribute("Height"),
			})
		)
	end

	for id, record in world:queryChanged(Components.Nami) do
		local instance = world:get(id, Components.Instance).Instance

		local height = record.new.Height
		SetModelHeight(instance, height)
	end
end
