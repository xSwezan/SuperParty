local Promise = require(script.Parent.Parent.Promise)

local Types = {}

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

	Teleport: (self: Party, PlaceId: number, Private: boolean?, TeleportData: any?, CustomLoadingScreen: GuiObject?) -> nil;

	IsMax: (self: Party) -> boolean;
	CanJoin: (self: Party, Player: Player) -> (boolean, Enum?);

	Destroy: (self: Party) -> nil;
	
	Players: {Player};
	PartyLeader: Player?;

	InviteList: {number};

	PlayerAdded: RBXScriptSignal;
	PlayerRemoved: RBXScriptSignal;
	PartyLeaderChanged: RBXScriptSignal;
	Destroyed: RBXScriptSignal;
}

export type SuperParty = {
	CreateParty: (Settings: PartySettings?) -> Party;
}

return Types