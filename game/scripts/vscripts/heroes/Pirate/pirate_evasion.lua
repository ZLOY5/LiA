pirate_evasion = class({})
LinkLuaModifier("modifier_pirate_evasion","heroes/Pirate/modifier_pirate_evasion.lua",LUA_MODIFIER_MOTION_NONE)

function pirate_evasion:GetIntrinsicModifierName()
	return "modifier_pirate_evasion"
end

