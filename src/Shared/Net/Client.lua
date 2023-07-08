local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RemoteFolder = ReplicatedStorage:WaitForChild("Net")

local function GetEvent(eventName: string)
	local event = RemoteFolder:WaitForChild(eventName, 5)

	if not event then
		error(`Event {eventName} not found`)
	end

	return event
end

local NetClient = {}

function NetClient.Connect(eventName: string, callback: (...any) -> ())
	local event = GetEvent(eventName)

	event.OnClientEvent:Connect(callback)
end

function NetClient.Fire(eventName: string, ...)
	local event = GetEvent(eventName)

	event:FireServer(...)
end

function NetClient.Invoke(eventName: string, ...)
	local event = GetEvent(eventName)

	return event:InvokeServer(...)
end

return NetClient
