export type Context = "Server" | "Client"

return function(ctx: Context)
	print(`Hello world, from {ctx}!`)
end
