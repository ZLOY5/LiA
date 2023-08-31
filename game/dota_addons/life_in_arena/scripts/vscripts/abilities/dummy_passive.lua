dummy_passive = class({})
LinkLuaModifier("modifier_dummy_passive","abilities/modifiers/modifier_dummy_passive.lua",LUA_MODIFIER_MOTION_NONE)

function dummy_passive:GetIntrinsicModifierName()
	return "modifier_dummy_passive"
end

