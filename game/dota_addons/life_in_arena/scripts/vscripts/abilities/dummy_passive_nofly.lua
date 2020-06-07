dummy_passive_nofly = class({})
LinkLuaModifier("modifier_dummy_passive_nofly","abilities/modifiers/modifier_dummy_passive_nofly.lua",LUA_MODIFIER_MOTION_NONE)

function dummy_passive_nofly:GetIntrinsicModifierName()
	return "modifier_dummy_passive_nofly"
end

