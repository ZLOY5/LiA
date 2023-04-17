modifier_tauren_champion_crushing_totem = class({})

function modifier_tauren_champion_crushing_totem:IsHidden()
	return false
end

function modifier_tauren_champion_crushing_totem:IsPurgable()
	return true
end

function modifier_tauren_champion_crushing_totem:OnCreated(kv)
	self.ability = self:GetAbility()
	self.parent = self:GetParent()

	self.bonus_attack_speed = self.ability:GetSpecialValueFor("bonus_attack_speed")
	self.attacks_count = self.ability:GetSpecialValueFor("attacks_count")
	self.damage_percent = self.ability:GetSpecialValueFor("cleave_percent")
	self.radius_start = self.ability:GetSpecialValueFor("cleave_start_width")
	self.radius_end = self.ability:GetSpecialValueFor("cleave_end_width")
	self.radius_dist = self.ability:GetSpecialValueFor("cleave_length")
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
				local damage = params.damage * self.damage_percent / 100
				DoCleaveAttack_IgnorePhysicalArmor(self.parent,	params.target, self.ability, damage, self.radius_start, self.radius_end, self.radius_dist, "particles/econ/items/faceless_void/faceless_void_weapon_bfury/faceless_void_weapon_bfury_cleave.vpcf")
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