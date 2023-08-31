modifier_knight_ancient_shield = class({})

function modifier_knight_ancient_shield:IsHidden()
	return false
end

function modifier_knight_ancient_shield:IsPurgable()
	return false
end

function modifier_knight_ancient_shield:OnCreated(kv)
	self.ranged_damage_reduction = self:GetAbility():GetSpecialValueFor("ranged_damage_reduction")
	self.bonus_magic_resistance = self:GetAbility():GetSpecialValueFor("bonus_magic_resistance")
	self.movement_speed_reduction = self:GetAbility():GetSpecialValueFor("movement_speed_reduction")
	self.reflect_chance = self:GetAbility():GetSpecialValueFor("reflect_chance")

	if IsServer() then
		self.pseudo = PseudoRandom:New(self.reflect_chance*0.01)
		self.bShouldBeReflected = false
	end
end

function modifier_knight_ancient_shield:OnRefresh(kv)
	self.incoming_damage_percentage = self:GetAbility():GetSpecialValueFor("incoming_damage_percentage")
end

function modifier_knight_ancient_shield:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
 
	return funcs
end

function modifier_knight_ancient_shield:OnAttackLanded(params) 
	if params.target == self:GetParent() and not self:GetParent():IsIllusion() then 
		print("ranged")
		self.attack_record = params.record 
		if self.pseudo:Trigger() then
			self.bShouldBeReflected = true
			local sProjectileName = params.attacker:GetRangedProjectileName()
			local iProjectileSpeed = params.attacker:GetProjectileSpeed()
			params.attacker.fAncientShieldReturnDamage = params.original_damage
			local info = {
					EffectName = sProjectileName,
					Ability = self:GetAbility(),
					iMoveSpeed = iProjectileSpeed,
					Source = self:GetCaster(),
					Target = params.attacker,
					iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
				}

			ProjectileManager:CreateTrackingProjectile( info )

			EmitSoundOn( "Hero_DragonKnight.DragonTail.Target", self:GetParent() )
		else 
			self.bShouldBeReflected = false
		end
	end 
end


function modifier_knight_ancient_shield:GetModifierIncomingPhysicalDamage_Percentage(params) 
	if IsServer() then
		if params.attacker:GetAttackCapability() == 2 and self.attack_record == params.record then 
			if self.bShouldBeReflected then
				return -100
			else
				return self.ranged_damage_reduction
			end
		end 
	end
end

function modifier_knight_ancient_shield:GetModifierMagicalResistanceBonus(params) 
	return self.bonus_magic_resistance
end

function modifier_knight_ancient_shield:GetModifierMoveSpeedBonus_Percentage(params) 
	return self.movement_speed_reduction
end