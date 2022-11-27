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

NewParty.SettingChanged:Connect(function(Name: string, Value: any)
	print(Name, Value)
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
	NewParty:Destroy()

	task.wait(1)
	NewParty:AddPlayer(Player)
end)

task.wait(3)

NewParty:SetSetting("MaxPlayers", 2)
print(NewParty.Settings)