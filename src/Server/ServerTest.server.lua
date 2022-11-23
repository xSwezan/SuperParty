local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SuperParty = require(ReplicatedStorage.MainModule)

local NewParty = SuperParty:CreateParty{
	MaxPlayers = 4;
}

NewParty.PlayerAdded:Connect(function(Player: Player)
	print(Player.Name, "joined!")
end)

NewParty.PlayerRemoved:Connect(function(Player: Player)
	print(Player.Name, "left!")
end)

NewParty.Removing:Connect(function()
	print("REMOVING PARTY!")
end)

Players.PlayerAdded:Connect(function(Player: Player)
	local Success, Status = NewParty:AddPlayer(Player)

	if not (Success) then
		print(Status)
	end

	print(NewParty)

	task.wait(5)
	NewParty:RemovePlayer(Player)
	NewParty:Destroy()

	print(NewParty)

	task.wait(1)
	print("yes")
	NewParty:AddPlayer(Player)
	print("YES")
end)