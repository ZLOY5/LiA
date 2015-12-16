fallen_champion_thorns = class({})

LinkLuaModifier("modifier_fallen_champion_thorns", "heroes/FallenChampion/modifier_fallen_champion_thorns.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_fallen_champion_thorns_aura", "heroes/FallenChampion/modifier_fallen_champion_thorns_aura.lua", LUA_MODIFIER_MOTION_NONE)

function fallen_champion_thorns:GetIntrinsicModifierName()
	return "modifier_fallen_champion_thorns"
end
