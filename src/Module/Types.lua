local Promise = require(script.Parent.Parent.Promise)
local Janitor = require(script.Parent.Parent.Janitor)

local Types = {}

export type Janitor = typeof(Janitor)
export type Promise = typeof(Promise)
export type Enum = string;

export type PartySettings = {
	MaxPlayers: number?;
	PartyMode: Enum?;
}

export type Party = {
	AddPlayer: (self: Party, Player: Player) -> boolean;
	RemovePlayer: (self: Party, Player: Player) -> boolean;

	Invite: (self: Party, Player: Player) -> nil;
	RemoveInvite: (self: Party, Player: Player) -> nil;

	SetSetting: (self: Party, Name: string, Value: any) -> nil;

	Teleport: (self: Party, PlaceId: number, Private: boolean?, TeleportData: any?, CustomLoadingScreen: GuiObject?) -> nil;

	IsMax: (self: Party) -> boolean;
	CanJoin: (self: Party, Player: Player) -> (boolean, Enum?);

	Destroy: (self: Party) -> nil;
	
	Settings: PartySettings;
	Janitor: Janitor;

	Players: {Player};
	PartyLeader: Player?;

	InviteList: {[number]: boolean};

	PlayerAdded: RBXScriptSignal;
	PlayerRemoved: RBXScriptSignal;
	PartyLeaderChanged: RBXScriptSignal;
	SettingChanged: RBXScriptSignal;
	Destroyed: RBXScriptSignal;
}

export type SuperParty = {
	CreateParty: (Settings: PartySettings?) -> Party;
}

return Types