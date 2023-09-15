shaman_resourcefulness = class ({})
LinkLuaModifier("modifier_shaman_resourcefulness", "heroes/Shaman/modifier_shaman_resourcefulness.lua", LUA_MODIFIER_MOTION_NONE)

function shaman_resourcefulness:GetIntrinsicModifierName()
	return "modifier_shaman_resourcefulness"
end