local Types = require(script.Types)
local PartyClass = require(script.Party)

local SuperParty = {}

SuperParty.Enum = require(script.Enums)

function SuperParty:CreateParty(PartySettings: Types.PartySettings): Types.Party
	return PartyClass.new(PartySettings)
end

return SuperParty