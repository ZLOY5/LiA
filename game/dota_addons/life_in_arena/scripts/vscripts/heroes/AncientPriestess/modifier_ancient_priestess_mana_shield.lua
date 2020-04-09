modifier_ancient_priestess_mana_shield = class({})

function modifier_ancient_priestess_mana_shield:IsPurgable()
	return false 
end

function modifier_ancient_priestess_mana_shield:GetEffectName()
	return "particles/medusa_mana_shield_custom.vpcf"
end

function modifier_ancient_priestess_mana_shield:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_ancient_priestess_mana_shield:GetBlockDamage(attack_damage)
	local parent = self:GetParent()

	if self:GetCaster():HasScepter() then
		self.absorption_percent = self:GetAbility():GetSpecialValueFor("absorption_percent_scepter")
		self.damage_per_mana = self:GetAbility():GetSpecialValueFor("damage_per_mana_scepter")
	else
		self.absorption_percent = self:GetAbility():GetSpecialValueFor("absorption_percent")
		self.damage_per_mana = self:GetAbility():GetSpecialValueFor("damage_per_mana")
	end
	
	local damage_abs = attack_damage * self.absorption_percent * 0.01

	local parent_mana = parent:GetMana()
	local mana_needed = damage_abs / self.damage_per_mana

	local damage_block = 0

	if mana_needed <= parent_mana then --если требуется маны меньше чем есть, то блокируем урон полностью
		damage_block = damage_abs
	else --если маны требуется больше чем есть, то блокируем часть урона и отключаем скилл
		damage_block = parent_mana * self.damage_per_mana
		mana_needed = parent_mana
		self:GetAbility():ToggleAbility()
	end

	local particle = ParticleManager:CreateParticle("particles/medusa_mana_shield_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
	ParticleManager:SetParticleControl(particle, 0, parent:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle, 1, Vector(mana_needed,0,0))

	EmitSoundOn("Hero_Medusa.ManaShield.Proc",parent)

	parent:SpendMana(mana_needed, self:GetAbility())
	return damage_block
end