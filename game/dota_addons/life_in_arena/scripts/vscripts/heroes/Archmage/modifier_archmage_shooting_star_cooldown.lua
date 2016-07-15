modifier_archmage_shooting_star_cooldown = class({})

function archmage_shooting_star:GetManaCost(level)
	local defManaCost = return self.BaseClass.GetManaCost( self, level )
	local chargeManaCost = self:GetSpecialValue("manacost_per_charge")
	return defManaCost + chargeManaCost*self.charges
end