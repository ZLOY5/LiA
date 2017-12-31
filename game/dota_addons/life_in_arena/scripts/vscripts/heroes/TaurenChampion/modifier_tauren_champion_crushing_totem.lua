modifier_tauren_champion_crushing_totem = class({})

function modifier_tauren_champion_crushing_totem:IsHidden()
	return false
end

function modifier_tauren_champion_crushing_totem:IsPurgable()
	return true
end

function modifier_tauren_champion_crushing_totem:OnCreated(kv)
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	self.attacks_count = self:GetAbility():GetSpecialValueFor("attacks_count")
	self.cleave_damage_percent = self:GetAbility():GetSpecialValueFor("cleave_damage_percent")
	self.cleave_starting_width = self:GetAbility():GetSpecialValueFor("cleave_starting_width")
	self.cleave_ending_width = self:GetAbility():GetSpecialValueFor("cleave_ending_width")
	self.cleave_distance = self:GetAbility():GetSpecialValueFor("cleave_distance")
	if IsServer() then
		self:SetStackCount(self.attacks_count)
		self.totemParticle = ParticleManager:CreateParticle("particles/econ/items/earthshaker/egteam_set/hero_earthshaker_egset/earthshaker_totem_buff_egset.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(self.totemParticle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_totem", Vector(0,0,0), false)
	end
end

function modifier_tauren_champion_crushing_totem:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
	}
 
	return funcs
end

function modifier_tauren_champion_crushing_totem:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end

function modifier_tauren_champion_crushing_totem:OnAttackLanded( params )
	if IsServer() then
		if self:GetParent() == params.attacker then
			if params.target ~= nil and params.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
				local cleaveDamage = ( self.cleave_damage_percent * params.damage ) / 100.0
				DoCleaveAttack( self:GetParent(), params.target, self:GetAbility(), cleaveDamage, self.cleave_starting_width, self.cleave_ending_width, self.cleave_distance, "particles/econ/items/faceless_void/faceless_void_weapon_bfury/faceless_void_weapon_bfury_cleave.vpcf" )
				self:DecrementStackCount()
				if self:GetStackCount() == 0 then
					self:GetParent():RemoveModifierByName( "modifier_tauren_champion_crushing_totem" )
				end
			end
		end
	end
end

function modifier_tauren_champion_crushing_totem:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.totemParticle, false)
	end
end

function modifier_tauren_champion_crushing_totem:GetActivityTranslationModifiers()
	return "enchant_totem"
end

function modifier_tauren_champion_crushing_totem:GetAttackSound()
	return "Hero_EarthShaker.Totem.Attack"
end