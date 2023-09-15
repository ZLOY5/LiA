walking_dead_vitality = class({})
LinkLuaModifier("modifier_walking_dead_vitality","heroes/WalkingDead/modifier_walking_dead_vitality.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_walking_dead_vitality_regen","heroes/WalkingDead/modifier_walking_dead_vitality_regen.lua",LUA_MODIFIER_MOTION_NONE)

function walking_dead_vitality:GetIntrinsicModifierName()
	return "modifier_walking_dead_vitality"
end

