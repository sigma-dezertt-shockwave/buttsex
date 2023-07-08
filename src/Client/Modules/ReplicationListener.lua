local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Components = require(ReplicatedStorage.Shared.Components)
local Net = require(ReplicatedStorage.Shared.Net.Client)

local EntityMap = {}

local function ReplicationListener(world)
	Net.Connect("EntityReplication", function(entities)
		for serverEntityId, componentMap in entities do
			local clientEntityId = EntityMap[serverEntityId]

			-- Entity despawned on the server
			if clientEntityId and next(componentMap) == nil then
				world:despawn(clientEntityId)
				EntityMap[serverEntityId] = nil

				continue
			end

			local componentsToInsert = {}
			local componentsToRemove = {}

			for name, container in componentMap do
				local component = Components[name]

				if container.data then
					table.insert(componentsToInsert, component(container.data))
				else
					table.insert(componentsToRemove, component)
				end
			end

			if not clientEntityId then
				clientEntityId = world:spawn(unpack(componentsToInsert))

				EntityMap[serverEntityId] = clientEntityId
			else
				if #componentsToInsert > 0 then
					world:insert(clientEntityId, unpack(componentsToInsert))
				end

				if #componentsToRemove > 0 then
					world:remove(clientEntityId, unpack(componentsToRemove))
				end
			end
		end
	end)
end

return ReplicationListener
