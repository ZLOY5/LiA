modifier_alchemist_unity = class({})

function modifier_alchemist_unity:IsHidden()
	return true
end

function modifier_alchemist_unity:IsPurgable()
	return false
end

function modifier_alchemist_unity:OnCreated(kv)
	self.iBonusStatsPercentage = self:GetAbility():GetSpecialValueFor( "bonus_stats_percentage" )
	if IsServer() then
		self:RecalculateStrength()
	end
end

function modifier_alchemist_unity:OnRefresh(kv)
	self.iBonusStatsPercentage = self:GetAbility():GetSpecialValueFor( "bonus_stats_percentage" )
	if IsServer() then
		self:RecalculateStrength()
	end
end

function modifier_alchemist_unity:RecalculateStrength()
	local hero = self:GetParent()
	hero:SetBaseStrength(hero:GetBaseIntellect() * self.iBonusStatsPercentage * 0.01)
end

function modifier_alchemist_unity:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_EVENT_ON_HERO_LEVEL_UP,
	}

	return funcs
end

function modifier_alchemist_unity:OnHeroLevelUp(params)
	if IsServer() then
		self:RecalculateStrength()
	end
end

function modifier_alchemist_unity:GetModifierBonusStats_Intellect()
	local hero = self:GetParent()
	return (hero:GetStrength() - hero:GetBaseStrength()) * self.iBonusStatsPercentage * 0.01
end
