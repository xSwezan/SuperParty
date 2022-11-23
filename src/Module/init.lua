local Types = require(script.Types)
local PartyClass = require(script.Party)

local SuperParty = {
	Enum = require(script.Enums);
	Types = Types;
}

function SuperParty:CreateParty(PartySettings: Types.PartySettings): Types.Party
	return PartyClass.new(PartySettings)
end

table.freeze(SuperParty)
return SuperParty