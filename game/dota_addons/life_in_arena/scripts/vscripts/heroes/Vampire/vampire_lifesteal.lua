vampire_lifesteal = class({})
LinkLuaModifier("modifier_vampire_lifesteal", "heroes/Vampire/modifier_vampire_lifesteal.lua", LUA_MODIFIER_MOTION_NONE)

function vampire_lifesteal:GetIntrinsicModifierName() 
	return "modifier_vampire_lifesteal"
end 

