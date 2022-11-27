local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local Types = require(script.Parent.Types)
local Janitor = require(script.Parent.Parent.Janitor)
local Promise = require(script.Parent.Parent.Promise)

local Enums = require(script.Parent.Enums)

local Party = {}
Party.__index = Party

if (RunService:IsClient()) then
	return {}
end

function Party.new(Settings: Types.PartySettings?)
	local self = setmetatable({}, Party)

	self.Janitor = Janitor.new()

	self:NewEvent("PlayerAdded")
	self:NewEvent("PlayerRemoved")
	self:NewEvent("PartyLeaderChanged")
	self:NewEvent("SettingChanged")
	self:NewEvent("Destroyed")

	self.Settings = Settings or {
		MaxPlayers = -1;
		PartyMode = Enums.PartyMode.Public;
	}

	self.Janitor:Add(Players.PlayerRemoving:Connect(function(Player: Player)
		self:RemovePlayer(Player)
	end))

	self.Players = {}
	self.PartyLeader = nil

	self.InviteList = {}

	return self
end

function Party:NewEvent(Name: string)
	self.Events = self.Events or {}

	self.Events[Name] = self.Janitor:Add(Instance.new("BindableEvent"), "Destroy")
	self[Name] = self.Events[Name].Event

	return self.Events[Name]
end

function Party:FireEvent(Name: string, ...)
	local Args: {any} = {...}

	local Event: BindableEvent = self.Events[Name]
	if not (Event) then return end

	Event:Fire(unpack(Args))
end

function Party:Invite(Player: Player)
	if (table.find(self.InviteList, Player.UserId)) then return end

	table.insert(self.InviteList, Player.UserId)
end

function Party:IsMax(): boolean
	if (self.Settings.MaxPlayers == -1) then return false end
	if (#self.Players >= self.Settings.MaxPlayers) then return true end

	return false
end

function Party:CanJoin(Player: Player): (boolean, Types.Enum?)
	if (self.Settings.PartyMode == Enums.PartyMode.Friends) then
		if (self.PartyLeader) and not (Player:IsFriendsWith(self.PartyLeader.UserId)) then
			return false, Enums.PartyStatus.OnlyFriends
		end
	end

	if (self.Settings.PartyMode == Enums.PartyMode.Private) then
		if (self.PartyLeader) and not (table.find(self.InviteList, Player.UserId)) then
			return false, Enums.PartyStatus.PartyIsPrivate
		end
	end

	return true
end

function Party:AddPlayer(Player: Player): (boolean, Types.Enum?)
	if (self:IsMax()) then return false, Enums.PartyStatus.MaxPlayers end

	local CanJoin, Status = self:CanJoin(Player)
	if not (CanJoin) then return false, Status end

	table.insert(self.Players, Player)

	if not (self.PartyLeader) then
		self.PartyLeader = Player
		self:FireEvent("PartyLeaderChanged", self.PartyLeader)
	end

	self:FireEvent("PlayerAdded", Player)

	return true
end

function Party:RemovePlayer(Player: Player): boolean
	local Index: number = table.find(self.Players, Player)
	if not (Index) then return false end

	table.remove(self.Players, Index)

	if (#self.Players == 0) or (self.PartyLeader == Player) then
		self.PartyLeader = self.Players[1]
		self:FireEvent("PartyLeaderChanged", self.PartyLeader)
	end

	self:FireEvent("PlayerRemoved", Player)

	return true
end

function Party:Kick(Player: Player): boolean
	local Index: number = table.find(self.Players, Player)
	if not (Index) then return false end

	table.remove(self.Players, Index)
	self:FireEvent("PlayerRemoved", Player, Enums.PartyStatus.Kicked)

	return true
end

function Party:Teleport(PlaceId: number, Private: boolean?, TeleportData: any?, CustomLoadingScreen: GuiObject?): boolean
	return Promise.new(function(resolve)
		assert(typeof(PlaceId) == "number", "Passed PlaceId is not a valid number!")

		if (Private) then
			local Code: string = TeleportService:ReserveServer(PlaceId)

			TeleportService:TeleportToPrivateServer(PlaceId, Code, self.Players, nil, TeleportData, CustomLoadingScreen)
		else
			TeleportService:TeleportPartyAsync(PlaceId, self.Players, TeleportData, CustomLoadingScreen)
		end

		resolve()
	end)
end

function Party:SetSetting(Name: string, Value: any)
	self.Settings[Name] = Value
	self:FireEvent("SettingChanged", Name, Value)
end

function Party:Destroy()
	self:FireEvent("Destroyed")

	self.Janitor:Destroy()

	table.clear(self)
	setmetatable(self, nil)
end

table.freeze(Party)
return Party