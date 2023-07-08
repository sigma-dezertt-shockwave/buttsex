local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Matter = require(ReplicatedStorage.Packages.Matter)

return {
	Instance = Matter.component("Instance", {
		Instance = nil,
	}),

	Nami = Matter.component("Nami", {
		Height = 100,
	}),
}
