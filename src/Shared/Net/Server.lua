local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RemoteFolder = Instance.new("Folder")
RemoteFolder.Name = "Net"
RemoteFolder.Parent = ReplicatedStorage

local NetServer = {}

function NetServer.CreateEvent(eventName: string)
	local event = Instance.new("RemoteEvent")
	event.Name = eventName
	event.Parent = RemoteFolder

	return event
end

function NetServer.CreateFunction(eventName: string)
	local event = Instance.new("RemoteFunction")
	event.Name = eventName
	event.Parent = RemoteFolder

	return event
end

function NetServer.ConnectEvent(eventName: string, callback: (...any) -> ())
	local event = RemoteFolder:FindFirstChild(eventName)

	if not event then
		event = NetServer.CreateEvent(eventName)
	end

	event.OnServerEvent:Connect(callback)
end

function NetServer.ConnectFunction(eventName: string, callback: (...any) -> ...any)
	local event = RemoteFolder:FindFirstChild(eventName)

	if not event then
		event = NetServer.CreateFunction(eventName)
	else
		error(`RemoteFunction {eventName} already exists, cannot connect to it`)
	end

	event.OnServerInvoke = callback
end

function NetServer.FireClient(player: Player, eventName: string, ...)
	local event = RemoteFolder:FindFirstChild(eventName)

	if not event then
		error(`Event {eventName} not found`)
	end

	event:FireClient(player, ...)
end

function NetServer.FireAllClients(eventName: string, ...)
	local event = RemoteFolder:FindFirstChild(eventName)

	if not event then
		error(`Event {eventName} not found`)
	end

	event:FireAllClients(...)
end

return NetServer
