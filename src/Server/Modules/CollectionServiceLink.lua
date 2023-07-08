local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Components = require(ReplicatedStorage.Shared.Components)

local function SpawnInstance(world, instance, component)
	local entityId

	for id, existingInstance in world:query(Components.Instance) do
		if existingInstance.Instance == instance then
			entityId = id
			break
		end
	end

	if not entityId then
		entityId = world:spawn(
			component(),
			Components.Instance({
				Instance = instance,
			})
		)

		instance:SetAttribute("EntityId", entityId)

		return entityId
	end

	world:insert(entityId, component())
	return entityId
end

local function SetupLink(world)
	for tag, component in Components do
		for _, instance in CollectionService:GetTagged(tag) do
			SpawnInstance(world, instance, component)
		end

		CollectionService:GetInstanceAddedSignal(tag):Connect(function(instance)
			SpawnInstance(world, instance, component)
		end)

		CollectionService:GetInstanceRemovedSignal(tag):Connect(function(instance)
			local id = instance:GetAttribute("EntityId")

			if id then
				world:despawn(id)
			end
		end)
	end
end

return SetupLink
