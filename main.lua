--[[
	GetConnections = https://docs.synapse.to/reference/environment.html
	GetConnectionsFunctions : 
		.Function	The function connected to the connection
		.State	The state of the connection
		:Enable	Enables the connection
		:Disable	Disables the connection
		:Fire	Fires the connection
		
	change the arguments of the passing functions then return the modified one
--]]
local tags = {
	example = {user = 1,tag = "test",color = Color3.fromRGB(8, 0, 255)}
}
local api = {
	createTag = function(user2,tag2,color2)
		table.insert(tags,{user = user2, tag = tag2,color = color2})
	end,
}

local players = game:GetService("Players")
for i,v in pairs(getconnections(game.ReplicatedStorage.DefaultChatSystemChatEvents.OnNewMessage.OnClientEvent)) do
	if v.Function ~= nil and #debug.getupvalues(v.Function) ~= 0 and type(debug.getupvalues(v.Function)[1]) == "table" and getmetatable(debug.getupvalues(v.Function)[1]).GetChannel ~= nil then
		oldfunc = getmetatable(debug.getupvalues(v.Function)[1]).GetChannel
		getmetatable(debug.getupvalues(v.Function)[1]).GetChannel = function(Self, Name)
			local v2 = oldfunc(Self, Name)
			if v2 and v2.AddMessageToChannel then
				local createMessage = v2.AddMessageToChannel
				v2.AddMessageToChannel = function(s, data)
					local chatter = players[(data.FromSpeaker)]
					if chatter ~= nil then
						for i2,tag in pairs(tags) do
							if tag.user == chatter.UserId then
								data.ExtraData = {
									NameColor = tag.color,
									Tags = {
										table.unpack(data.ExtraData.Tags),
										{
											TagColor = tag.color,
											TagText = tag.tag
										}
									}
								}
							end
						end
					end
					return createMessage(s, data)
				end
			end
			return v2
		end
	end
end

return api
