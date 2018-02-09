modifier_warlock_firestorm_burn = class ({})

function modifier_warlock_firestorm_burn:IsHidden()
	return false
end

function modifier_warlock_firestorm_burn:IsPurgable()
	return true
end

function modifier_warlock_firestorm_burn:OnCreated(kv)
	self.burn_interval = self:GetAbility():GetSpecialValueFor("burn_interval")
	
	if self:GetCaster():HasScepter() then
		self.burn_damage = self:GetAbility():GetSpecialValueFor( "burn_damage_scepter" )
	else
		self.burn_damage = self:GetAbility():GetSpecialValueFor( "burn_damage" )
	end

	if IsServer() then
		self:StartIntervalThink(self.burn_interval)
	end
end
 
function modifier_warlock_firestorm_burn:GetEffectName()
	return "particles/custom/neutral/firestorm_wave_burn.vpcf"
end

function modifier_warlock_firestorm_burn:GetEffectAttachType()
	return PATTACH_CUSTOMORIGIN_FOLLOW
end

function modifier_warlock_firestorm_burn:OnIntervalThink()
	if IsServer() then
		ApplyDamage({ victim = self:GetParent(), attacker = self:GetCaster(), ability = self:GetAbility(), damage_type = DAMAGE_TYPE_MAGICAL, damage = self.burn_damage })
	end
end