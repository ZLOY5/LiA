modifier_kret_poisoning = class({})

function modifier_kret_poisoning:IsHidden()
	return true
end

function modifier_kret_poisoning:IsPurgable()
	return false
end

function modifier_kret_poisoning:OnCreated(kv)
	self.damage = self:GetAbility():GetSpecialValueFor("damage")
	self.mana_burn = self:GetAbility():GetSpecialValueFor("mana_burn")
	self.chance = self:GetAbility():GetSpecialValueFor("chance")

	if IsServer() then
		self.pseudo = PseudoRandom:New(self.chance*0.01)
	end
end

function modifier_kret_poisoning:OnRefresh(kv)
	self.damage = self:GetAbility():GetSpecialValueFor("damage")
	self.mana_burn = self:GetAbility():GetSpecialValueFor("mana_burn")
end

function modifier_kret_poisoning:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
 
	return funcs
end

function modifier_kret_poisoning:OnAttackLanded( params )
	if IsServer() then
		if self:GetParent() == params.target then

			if self:GetParent():PassivesDisabled() then
				return 
			end

			local hTarget = params.attacker
			if hTarget ~= nil and self.pseudo:Trigger() then
				local damageTable = {
						 	victim = params.attacker, 
						 	attacker = params.target, 
						 	damage = self.damage, 
						 	damage_type = DAMAGE_TYPE_PHYSICAL,
						 	ability = self:GetAbility()
						}

				ApplyDamage(damageTable)
				params.attacker:ManaBurn(self:GetParent(), self:GetAbility(), self.mana_burn, nil, nil, true)

				local nFXIndex = ParticleManager:CreateParticle( "particles/custom/kret/kret_poisonous_scales.vpcf", PATTACH_CUSTOMORIGIN, nil )
				ParticleManager:SetParticleControl( nFXIndex, 0, params.attacker:GetOrigin() )
				ParticleManager:SetParticleControl( nFXIndex, 3, params.attacker:GetOrigin() )
				EmitSoundOn("Hero_Slark.Pounce.Impact", params.attacker)

			end
		end
	end

end
