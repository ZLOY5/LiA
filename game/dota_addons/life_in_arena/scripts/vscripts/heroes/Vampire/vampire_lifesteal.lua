vampire_lifesteal = class({})
LinkLuaModifier("modifier_vampire_lifesteal", "heroes/Vampire/modifier_vampire_lifesteal.lua", LUA_MODIFIER_MOTION_NONE)

function vampire_lifesteal:GetIntrinsicModifierName() 
	return "modifier_vampire_lifesteal"
end 

function vampire_lifesteal:OnUpgrade() 
	self:GetCaster().thirst_points_max = self:GetSpecialValueFor("thirst_points_max")
end
