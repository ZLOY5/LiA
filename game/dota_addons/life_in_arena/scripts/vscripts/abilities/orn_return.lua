orn_return = class({})
LinkLuaModifier("modifier_orn_return", "abilities/modifier_orn_return.lua",LUA_MODIFIER_MOTION_NONE)

function orn_return:GetIntrinsicModifierName()
	return "modifier_orn_return"
end