modifier_alchemist_unity = class({})

function modifier_alchemist_unity:IsHidden()
	return true
end

function modifier_alchemist_unity:IsPurgable()
	return false
end

function modifier_alchemist_unity:OnCreated(kv)
	if IsServer() then
		self.hero = self:GetParent()
		self.iBonusStatsPercentage = self:GetAbility():GetSpecialValueFor( "bonus_stats_percentage" )
		self.fBaseIntellect = self.hero:GetBaseIntellect()
		self.fNewBaseStrength = self.fBaseIntellect * self.iBonusStatsPercentage * 0.01
		self.hero:SetBaseStrength(self.fNewBaseStrength)
	end
end

function modifier_alchemist_unity:OnRefresh(kv)
	if IsServer() then
		self.iBonusStatsPercentage = self:GetAbility():GetSpecialValueFor( "bonus_stats_percentage" )
		self.fBaseIntellect = self.hero:GetBaseIntellect()
		self.fNewBaseStrength = self.fBaseIntellect * self.iBonusStatsPercentage * 0.01
		self.hero:SetBaseStrength(self.fNewBaseStrength)
	end
end

function modifier_alchemist_unity:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
 
	return funcs
end

function modifier_alchemist_unity:GetModifierBonusStats_Intellect()
	local fBonusIntellect = (self.hero:GetStrength() - self.hero:GetBaseStrength()) * self.iBonusStatsPercentage * 0.01
	return fBonusIntellect 
end
