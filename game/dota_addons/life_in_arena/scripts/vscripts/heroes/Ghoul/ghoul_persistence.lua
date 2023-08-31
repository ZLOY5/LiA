ghoul_persistence = class({})
LinkLuaModifier("modifier_ghoul_persistence", "heroes/Ghoul/modifier_ghoul_persistence", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ghoul_persistence_effect", "heroes/Ghoul/modifier_ghoul_persistence_effect", LUA_MODIFIER_MOTION_NONE)

function ghoul_persistence:GetIntrinsicModifierName() 
	return "modifier_ghoul_persistence"
end

