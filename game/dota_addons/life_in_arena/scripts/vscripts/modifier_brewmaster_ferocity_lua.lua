modifier_brewmaster_ferocity_lua = class({})

function modifier_brewmaster_ferocity_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	}
 
	return funcs
end

function modifier_brewmaster_ferocity_lua:GetModifierBonusStats_Strength(params)
	return self.bonus_strength
end

function modifier_brewmaster_ferocity_lua:OnCreated(event)
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	if IsServer() then
		self:OnIntervalThink()
		self:StartIntervalThink( 0.2 )
	end
end

function modifier_brewmaster_ferocity_lua:OnIntervalThink(event)
	self.bonus_strength_per_unit = self:GetAbility():GetSpecialValueFor("bonus_strength")
	if IsServer() then
		local units = FindUnitsInRadius(self:GetParent():GetTeam(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		self.bonus_strength = self.bonus_strength_per_unit * #units
		self:GetParent():CalculateStatBonus()
		--self:ForceRefresh()
	end
end