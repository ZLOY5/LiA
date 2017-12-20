kret_poisoning = class({})
LinkLuaModifier("modifier_kret_poisoning","heroes/Kret/modifier_kret_poisoning.lua",LUA_MODIFIER_MOTION_NONE)

function kret_poisoning:GetIntrinsicModifierName()
	return "modifier_kret_poisoning"
end