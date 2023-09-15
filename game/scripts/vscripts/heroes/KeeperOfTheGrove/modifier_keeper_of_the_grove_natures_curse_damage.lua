modifier_keeper_of_the_grove_natures_curse_damage = class ({})

function modifier_keeper_of_the_grove_natures_curse_damage:IsHidden()
	return false
end

function modifier_keeper_of_the_grove_natures_curse_damage:IsPurgable()
	return true
end

function modifier_keeper_of_the_grove_natures_curse_damage:OnCreated(kv)	
	if self:GetCaster():HasScepter() then
		self.damage_per_second = self:GetAbility():GetSpecialValueFor( "damage_per_second_scepter" )
	else
		self.damage_per_second = self:GetAbility():GetSpecialValueFor( "damage_per_second" )
	end

	if IsServer() then
		self:StartIntervalThink(1)
	end
end
 
function modifier_keeper_of_the_grove_natures_curse_damage:GetEffectName()
	return "particles/units/heroes/hero_enchantress/enchantress_untouchable.vpcf"
end

function modifier_keeper_of_the_grove_natures_curse_damage:GetEffectAttachType()
	return PATTACH_CUSTOMORIGIN_FOLLOW
end

function modifier_keeper_of_the_grove_natures_curse_damage:OnIntervalThink()
	if IsServer() then
		ApplyDamage({ victim = self:GetParent(), attacker = self:GetCaster(), ability = self:GetAbility(), damage_type = DAMAGE_TYPE_MAGICAL, damage = self.damage_per_second })
	end
end