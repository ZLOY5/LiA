item_lia_health_stone_potion = class({})
LinkLuaModifier("modifier_item_lia_health_stone_potion","items/item_lia_health_stone_potion.lua",LUA_MODIFIER_MOTION_NONE)

function item_lia_health_stone_potion:GetIntrinsicModifierName()
	return "modifier_item_lia_health_stone_potion"
end

function item_lia_health_stone_potion:CastFilterResult()
	if self:GetCaster():GetHealthPercent() == 100 then
		return UF_FAIL_CUSTOM
	end
	return UF_SUCCESS
end

function item_lia_health_stone_potion:GetCustomCastError()
	return "lia_hud_error_heal_potion_full_hp"
end

function item_lia_health_stone_potion:OnSpellStart()
	self:GetCaster():Heal(self:GetSpecialValueFor("heal_amount"), self)

	local particle = ParticleManager:CreateParticle("particles/items_fx/healing_flask.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	Timers:CreateTimer(1, function()
		ParticleManager:DestroyParticle(particle,false)
		ParticleManager:ReleaseParticleIndex(particle)
	end)
	
	self:SetCurrentCharges(self:GetCurrentCharges()-1)
	if self:GetCurrentCharges() == 0 then
		self:RemoveSelf()
	end
end

-----------------------------------------------------------------------

modifier_item_lia_health_stone_potion = class({})

function modifier_item_lia_health_stone_potion:IsHidden()
	return true
end

function modifier_item_lia_health_stone_potion:IsPurgable()
	return false
end

function modifier_item_lia_health_stone_potion:RemoveOnDeath()
	return false
end

function modifier_item_lia_health_stone_potion:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}
 
	return funcs
end

function modifier_item_lia_health_stone_potion:GetModifierConstantHealthRegen()
	return self.healthRegen
end

function modifier_item_lia_health_stone_potion:OnCreated()
	self.healthRegen = self:GetAbility():GetSpecialValueFor("bonus_health_regen")
end