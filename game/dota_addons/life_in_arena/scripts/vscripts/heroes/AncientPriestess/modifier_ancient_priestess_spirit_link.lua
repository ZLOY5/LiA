modifier_ancient_priestess_spirit_link = class({})

require('LiA_Common')

function modifier_ancient_priestess_spirit_link:GetEffectName()
	return "particles/wisp_overcharge_custom.vpcf"
end

function modifier_ancient_priestess_spirit_link:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

--end

function modifier_ancient_priestess_spirit_link:IsBuff() 
	return true 
end

function modifier_ancient_priestess_spirit_link:IsPurgable() 
	return true 
end

function modifier_ancient_priestess_spirit_link:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}
 
	return funcs
end

function modifier_ancient_priestess_spirit_link:GetModifierConstantHealthRegen()
	return self.health_regen
end

function modifier_ancient_priestess_spirit_link:OnCreated(kv)
	self.health_regen = self:GetAbility():GetSpecialValueFor("heal_value")
	self.distr_factor = self:GetAbility():GetSpecialValueFor("distribution_factor")
end

function modifier_ancient_priestess_spirit_link:OnDestroy()
	if IsServer() then
		table.remove(self.tTargets,getIndex(self.tTargets, self:GetParent()))
	end
end

function modifier_ancient_priestess_spirit_link:LinkDamage(attack_damage,damage_type,attacker,ability) --эта функция вызывается из фильтра урона и возращает кол-во заблокированного(переданого остальным юнитам) урона
	local nLinkedUnits = #self.tTargets
	local damage = attack_damage*self.distr_factor
	local linked_damage = attack_damage/nLinkedUnits

	if nLinkedUnits == 1 then
		return 0
	end

	for _,unit in pairs(self.tTargets) do
		unit.spiritLink_damage = true
		ApplyDamage({victim = unit, attacker = attacker, damage = linked_damage, damage_type = damage_type, ability = ability or self:GetAbility(), damage_flags = DOTA_DAMAGE_FLAG_NON_LETHAL})
	end

	return damage
end