modifier_wave_1_poison = class({})

------------------------------------------------------------------------------------

function modifier_wave_1_poison:IsHidden()
	return true
end

------------------------------------------------------------------------------------

function modifier_wave_1_poison:OnCreated( kv )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
end
------------------------------------------------------------------------------------

function modifier_wave_1_poison:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end


------------------------------------------------------------------------------------

function modifier_wave_1_poison:OnAttackLanded( params )
	if IsServer() then
		if IsServer() then
			if self:GetParent():PassivesDisabled() then
				return
			end

			if self:GetParent() ~= params.attacker then
				return 0
			end
			
			local hTarget = params.target
			local hAttacker = params.attacker

			if hTarget == nil or hAttacker == nil or self:GetAbility() == nil then
				return 0
			end

			if hAttacker:IsIllusion() then
				return 0
			end

			if hAttacker:GetTeamNumber() == hTarget:GetTeamNumber() then
				return 0
			end

			hTarget:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_wave_1_poison_debuff", { duration = self.duration } )

		end
	end
end

------------------------------------------------------------------------------------

modifier_wave_1_poison_debuff = class({})

------------------------------------------------------------------------------------

function modifier_wave_1_poison_debuff:IsPurgable()
	return true
end

------------------------------------------------------------------------------------

function modifier_wave_1_poison_debuff:GetEffectName()
	return "particles/units/heroes/hero_viper/viper_poison_debuff.vpcf"
end

------------------------------------------------------------------------------------

function modifier_wave_1_poison_debuff:OnCreated( kv )
	self.movement_slow = self:GetAbility():GetSpecialValueFor( "movement_slow" )
	self.attack_slow = self:GetAbility():GetSpecialValueFor( "attack_slow" )
	self.damage_per_second = self:GetAbility():GetSpecialValueFor( "damage_per_second" )

	if IsServer() then
		self:OnIntervalThink()
		self:StartIntervalThink(1)
	end
end

--------------------------------------------------------------------------------

function modifier_wave_1_poison_debuff:OnIntervalThink()
	if IsServer() then
		local flDamage = self.damage_per_second

		local damage = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = flDamage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility()
		}

		ApplyDamage( damage )
	end
end

------------------------------------------------------------------------------------

function modifier_wave_1_poison_debuff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs
end

------------------------------------------------------------------------------------

function modifier_wave_1_poison_debuff:GetModifierMoveSpeedBonus_Percentage( params )
	return self.movement_slow
end

--------------------------------------------------------------------------------

function modifier_wave_1_poison_debuff:GetModifierAttackSpeedBonus_Constant( params )
	return self.attack_slow
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

