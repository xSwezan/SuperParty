local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SuperParty = require(ReplicatedStorage.Packages.MainModule)

local NewParty = SuperParty:CreateParty{
	MaxPlayers = 4;
}

NewParty.PlayerAdded:Connect(function(Player: Player)
	print(Player.Name, "joined!")
end)

NewParty.PlayerRemoved:Connect(function(Player: Player)
	print(Player.Name, "left!")
end)

NewParty.Destroyed:Connect(function()
	print("REMOVING PARTY!")
end)

Players.PlayerAdded:Connect(function(Player: Player)
	local Success, Status = NewParty:AddPlayer(Player)

	if not (Success) then
		print(Status)
	end
	
	task.wait(5)
	NewParty:RemovePlayer(Player)
	print("start destroy")
	print(NewParty)
	NewParty:Destroy()
	warn(NewParty)
	print("end destroy")

	print(NewParty)

	task.wait(1)
	print("yes")
	NewParty:AddPlayer(Player)
	print("YES")
end)