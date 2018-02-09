orn_mana_break = class({})
LinkLuaModifier("modifier_mana_break", "abilities/modifiers/modifier_mana_break.lua", LUA_MODIFIER_MOTION_NONE)

function orn_mana_break:GetIntrinsicModifierName()
	return "modifier_mana_break"
end

