local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Matter = require(ReplicatedStorage.Packages.Matter)

local World = Matter.World.new()
local Loop = Matter.Loop.new(World)

local Systems = {}
for _, Child in script.Systems:GetChildren() do
	table.insert(Systems, require(Child))
end

Loop:scheduleSystems(Systems)
Loop:begin({
	default = RunService.Heartbeat,
})
