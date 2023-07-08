local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Matter = require(ReplicatedStorage.Packages.Matter)

local Components = require(ReplicatedStorage.Shared.Components)
local Net = require(ReplicatedStorage.Shared.Net.Server)

local ReplicatedComponentNames = require(ReplicatedStorage.Shared.Components.Replicated)
local ReplicatedComponents = {}
for _, name in ReplicatedComponentNames do
	ReplicatedComponents[Components[name]] = true
end

Net.CreateEvent("EntityReplication")

local function ReplicateSender(world)
	local changes = {}

	for component in ReplicatedComponents do
		for entityId, record in world:queryChanged(component) do
			local key = tostring(entityId)
			local name = tostring(component)

			if not changes[key] then
				changes[key] = {}
			end

			if not world:contains(entityId) then
				continue
			end

			changes[key][name] = { data = record.new }
		end
	end

	if next(changes) then
		Net.FireAllClients("EntityReplication", changes)
	end

	for _, player in Matter.useEvent(Players, "PlayerAdded") do
		local payload = {}

		for entityId, entityData in world do
			local entityPayload = {}

			for component, componentData in entityData do
				if ReplicatedComponents[component] then
					entityPayload[tostring(component)] = { data = componentData }
				end
			end

			payload[tostring(entityId)] = entityPayload
		end

		Net.FireClient(player, "EntityReplication", payload)
	end
end

return {
	system = ReplicateSender,
	priority = math.huge,
}
