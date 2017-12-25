modifier_wanderer_arcane_aura = class({})

function modifier_wanderer_arcane_aura:IsHidden() 
	return true 
end

function modifier_wanderer_arcane_aura:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_wanderer_arcane_aura:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_wanderer_arcane_aura:GetModifierAura()
	return "modifier_wanderer_arcane_aura_effect"
end

--------------------------------------------------------------------------------

function modifier_wanderer_arcane_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------

function modifier_wanderer_arcane_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

--------------------------------------------------------------------------------

function modifier_wanderer_arcane_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

--------------------------------------------------------------------------------

function modifier_wanderer_arcane_aura:GetAuraRadius()
	return self.aura_radius
end

--------------------------------------------------------------------------------

function modifier_wanderer_arcane_aura:OnCreated( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "aura_radius" )
	self.enemy_effect_radius = self:GetAbility():GetSpecialValueFor( "enemy_effect_radius" )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.slow_duration = self:GetAbility():GetSpecialValueFor( "slow_duration" )
end

--------------------------------------------------------------------------------

function modifier_wanderer_arcane_aura:OnRefresh( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "aura_radius" )
	self.enemy_effect_radius = self:GetAbility():GetSpecialValueFor( "enemy_effect_radius" )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.slow_duration = self:GetAbility():GetSpecialValueFor( "slow_duration" )
end

--------------------------------------------------------------------------------

function modifier_wanderer_arcane_aura:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}
 
	return funcs
end

--------------------------------------------------------------------------------

function modifier_wanderer_arcane_aura:OnAbilityFullyCast(params)
	if IsServer() then  
		print("gogokilla")
		if self:GetCaster():PassivesDisabled() then
			return
		end
		
		if params.unit:GetRangeToUnit(self:GetCaster()) <= self.enemy_effect_radius and params.unit:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then 
			if params.ability:IsItem() and not params.ability:IsPermanent() or params.ability:GetAbilityName() == "troll_cuthroat_boomeang_axe_return" then
				return 
			end

			ApplyDamage({ victim = params.unit, attacker = self:GetParent(), damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility() })
			params.unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_wanderer_arcane_aura_slow", {duration = self.slow_duration})
			EmitSoundOn("Hero_Silencer.LastWord.Damage", params.unit)
		end
	end 
end