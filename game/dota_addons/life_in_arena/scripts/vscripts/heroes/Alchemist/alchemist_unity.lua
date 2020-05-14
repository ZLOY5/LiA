alchemist_unity = class({})
LinkLuaModifier("modifier_alchemist_unity","heroes/Alchemist/modifier_alchemist_unity.lua",LUA_MODIFIER_MOTION_NONE)

function alchemist_unity:GetIntrinsicModifierName()
	return "modifier_alchemist_unity"
end

function alchemist_unity:OnHeroLevelUp()
	local modiffier = self:GetCaster():FindModifierByName("modifier_alchemist_unity")
	if modiffier then modiffier:ForceRefresh() end
end