fallen_champion_return = class({})

LinkLuaModifier("modifier_fallen_champion_return", "heroes/FallenChampion/modifier_fallen_champion_return.lua", LUA_MODIFIER_MOTION_NONE)

function fallen_champion_return:GetIntrinsicModifierName()
	return "modifier_fallen_champion_return"
end