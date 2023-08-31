modifier_butcher_zombie_bonus_stats = class({})

--------------------------------------------------------------------------------

function modifier_butcher_zombie_bonus_stats:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_butcher_zombie_bonus_stats:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_butcher_zombie_bonus_stats:OnCreated( kv )
	if IsServer() then
		self.bonus_max_health = self:GetCaster():GetMaxHealth() * self:GetAbility():GetSpecialValueFor( "zombie_butcher_heath_percent" ) * 0.01
	end
end

--------------------------------------------------------------------------------

function modifier_butcher_zombie_bonus_stats:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_butcher_zombie_bonus_stats:GetModifierExtraHealthBonus( params )
	return self.bonus_max_health
end

--------------------------------------------------------------------------------
