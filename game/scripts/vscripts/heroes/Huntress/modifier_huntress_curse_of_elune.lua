modifier_huntress_curse_of_elune = class({})

function modifier_huntress_curse_of_elune:IsHidden()
	return false
end

function modifier_huntress_curse_of_elune:IsPurgable()
	return true
end

function modifier_huntress_curse_of_elune:OnCreated(kv)
	if IsServer() then
        self.parent = self:GetParent()
        self.damage_initial = self:GetAbility():GetSpecialValueFor( "damage_initial" )
        self.damage_per_second = self:GetAbility():GetSpecialValueFor( "damage_per_second" )
        if not string.find(self.parent:GetUnitName(),"megaboss") and not self.parent:IsHero() then
            self.percentage_damage = self:GetAbility():GetSpecialValueFor( "damage_hp_percentage_creeps" ) / 100
        else
            self.percentage_damage = self:GetAbility():GetSpecialValueFor( "damage_hp_percentage_heroes" ) / 100
        end

		local damage = {
				victim = self:GetParent(),
				attacker = self:GetCaster(),
				damage = self.damage_initial,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self:GetAbility()
			}

		ApplyDamage( damage )

		self:StartIntervalThink( 1 )
	end
end

function modifier_huntress_curse_of_elune:GetStatusEffectName()
	return "particles/status_fx/status_effect_maledict.vpcf"
end

function modifier_huntress_curse_of_elune:StatusEffectPriority()
	return 10
end

function modifier_huntress_curse_of_elune:OnIntervalThink()
	if IsServer() then
        local damage_to_deal = (self.parent:GetMaxHealth() - self.parent:GetHealth()) * self.percentage_damage + self.damage_per_second

		local damage = {
				victim = self:GetParent(),
				attacker = self:GetCaster(),
				damage = damage_to_deal,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self:GetAbility()
			}

		ApplyDamage( damage )
	end
end