ancient_priestess_mana_shield_staff = class({})
LinkLuaModifier("modifier_ancient_priestess_mana_shield", "heroes/AncientPriestess/modifier_ancient_priestess_mana_shield.lua", LUA_MODIFIER_MOTION_NONE)

function ancient_priestess_mana_shield_staff:OnToggle() 
	if self:GetToggleState() then 
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_ancient_priestess_mana_shield", nil)
		EmitSoundOn("Hero_Medusa.ManaShield.On", self:GetCaster())
	else 
		self:GetCaster():RemoveModifierByName("modifier_ancient_priestess_mana_shield")
		EmitSoundOn("Hero_Medusa.ManaShield.Off", self:GetCaster())
	end
end