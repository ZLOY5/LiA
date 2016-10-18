modifier_dark_ranger_spiked_charm_aura = class({})

function modifier_dark_ranger_spiked_charm_aura:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
 
	return funcs
end

function modifier_dark_ranger_spiked_charm_aura:IsPurgable()
	return false
end

function modifier_dark_ranger_spiked_charm_aura:OnAttackLanded(params) 
	if IsServer() then
		if params.target == self:GetParent() and not self:GetParent():HasModifier("modifier_illusion") then 
			self.attack_record = params.record 
			self.ranged_attack = params.ranged_attack
		end 
	end
end


function modifier_dark_ranger_spiked_charm_aura:OnTakeDamage(params)
	if IsServer() then
		if params.unit == self:GetParent() and not self:GetParent():HasModifier("modifier_illusion") and not IsFlagSet(params.damage_flags,DOTA_DAMAGE_FLAG_REFLECTION) then
			
			if self:GetParent():PassivesDisabled() then
				return 0
			end

			if self.attack_record == params.record and not self.ranged_attack then
				local target = params.unit
				local return_damage = self:GetAbility():GetSpecialValueFor("damage_return")*0.01*params.original_damage
				
				ApplyDamage(
				{
					victim = params.attacker, 
					attacker = target, 
					damage = return_damage, 
					damage_type = DAMAGE_TYPE_MAGICAL,
					damage_flags = DOTA_DAMAGE_FLAG_REFLECTION,
					ability = self:GetAbility()
				})
			end
		end
	end
end