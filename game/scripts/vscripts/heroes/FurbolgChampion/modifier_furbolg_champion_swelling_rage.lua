modifier_furbolg_champion_swelling_rage = class({})

function modifier_furbolg_champion_swelling_rage:IsHidden()
	return true
end

function modifier_furbolg_champion_swelling_rage:IsPurgable()
	return false
end

function modifier_furbolg_champion_swelling_rage:OnCreated(kv)
	self.health_lost_percentage_required = self:GetAbility():GetSpecialValueFor("health_lost_percentage_required")
	self.damage_required = self:CalculateDamage()
end

function modifier_furbolg_champion_swelling_rage:OnRefresh(kv)
	self.health_lost_percentage_required = self:GetAbility():GetSpecialValueFor("health_lost_percentage_required")
end

function modifier_furbolg_champion_swelling_rage:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
 
	return funcs
end

function modifier_furbolg_champion_swelling_rage:CalculateDamage()
	return self:GetParent():GetMaxHealth() * self.health_lost_percentage_required * 0.01
end

function modifier_furbolg_champion_swelling_rage:OnTakeDamage(params)
	if params.unit == self:GetParent() and not self:GetParent():IsIllusion() and not (params.damage_flags % (2*DOTA_DAMAGE_FLAG_REFLECTION) >= DOTA_DAMAGE_FLAG_REFLECTION) then
		if self:GetParent():PassivesDisabled() then
			return 0
		end

		self.damage_required = self.damage_required - params.damage

		local furious_clap = self:GetParent():FindAbilityByName("furbolg_champion_furious_clap")
		if self.damage_required <= 0 and furious_clap:GetLevel() > 0 then
			furious_clap:OnSpellStart()
			self.damage_required = self:CalculateDamage()
			self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel()))
		end	
	end
end