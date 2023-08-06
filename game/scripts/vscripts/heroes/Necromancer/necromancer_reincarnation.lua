necromancer_reincarnation = class({})
LinkLuaModifier("modifier_necromancer_reincarnation", "heroes/Necromancer/modifier_necromancer_reincarnation.lua",LUA_MODIFIER_MOTION_NONE)

function necromancer_reincarnation:GetIntrinsicModifierName()
	return "modifier_necromancer_reincarnation"
end