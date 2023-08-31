item_lia_pure_light = class({})

LinkLuaModifier("modifier_pure_light","items/modifier_pure_light.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pure_light_aura","items/modifier_pure_light_aura.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pure_light_thinker","items/modifier_pure_light_thinker.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pure_light_protection","items/modifier_pure_light_protection.lua",LUA_MODIFIER_MOTION_NONE)

function item_lia_pure_light:GetIntrinsicModifierName()
	return "modifier_pure_light"
end

function item_lia_pure_light:OnSpellStart()
	CreateModifierThinker(
		self:GetCaster(),
		self,
		"modifier_pure_light_thinker",
		{ 
			duration = self:GetSpecialValueFor("totem_duration") 
		},
		self:GetCursorPosition(),
		self:GetCaster():GetTeamNumber(),
		false
	)	
end											