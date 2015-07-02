modifier_butcher_skin = class ({})

function modifier_butcher_skin:IsHidden()
	return true
end

function modifier_butcher_skin:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
 
	return funcs
end

function modifier_butcher_skin:GetModifierPhysicalArmorBonus(params)
	return self.bonus_armor
end

function modifier_butcher_skin:OnCreated(kv)
	self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
end

function modifier_butcher_skin:OnRefresh(kv)
	self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
end

function modifier_butcher_skin:OnAttackLanded(params)
	if IsServer() then
		if params.target == self:GetParent() and (not self:GetParent():IsIllusion()) and not params.ranged_attack then
			if self:GetParent():PassivesDisabled() then
				return 0
			end

			local target = params.target
			local return_damage = self:GetAbility():GetSpecialValueFor("damage_return")*0.01*params.damage
			ApplyDamage(
			{
				victim = params.attacker, 
				attacker = target, 
				damage = return_damage, 
				damage_type = DAMAGE_TYPE_MAGICAL,
				damage_flags = DOTA_DAMAGE_FLAG_REFLECTION
			})
		end
	end
end