item_lia_fire_gloves = class({})
item_lia_fire_gloves_2 = item_lia_fire_gloves

LinkLuaModifier("modifier_fire_gloves","items/modifier_fire_gloves.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_fire_gloves_immolation","items/modifier_fire_gloves_immolation.lua",LUA_MODIFIER_MOTION_NONE)

function item_lia_fire_gloves:GetIntrinsicModifierName()
	return "modifier_fire_gloves"
end

function item_lia_fire_gloves:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_fire_gloves_immolation") then
		return self.BaseClass.GetAbilityTextureName(self)
	else
		return "custom/lia_fire_gloves_disabled"
	end
end

function item_lia_fire_gloves:OnToggle()
	if self:GetToggleState() then 
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_fire_gloves_immolation", nil)
		EmitSoundOn("Hero_EmberSpirit.FlameGuard.Cast", self:GetCaster())
	else 
		self:GetCaster():RemoveModifierByName("modifier_fire_gloves_immolation")
	end
end