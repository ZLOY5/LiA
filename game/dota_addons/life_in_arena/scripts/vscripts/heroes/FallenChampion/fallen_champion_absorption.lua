fallen_champion_absorption = class ({})
LinkLuaModifier("modifier_fallen_champion_absorption", "heroes/FallenChampion/modifier_fallen_champion_absorption.lua", LUA_MODIFIER_MOTION_NONE)

function fallen_champion_absorption:GetIntrinsicModifierName()
	return "modifier_fallen_champion_absorption"
end