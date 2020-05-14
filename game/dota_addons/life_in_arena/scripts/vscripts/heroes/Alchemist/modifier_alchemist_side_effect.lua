modifier_alchemist_side_effect = class({})

function modifier_alchemist_side_effect:IsHidden()
	return false
end

function modifier_alchemist_side_effect:IsPurgable()
	return false
end

function modifier_alchemist_side_effect:OnCreated(kv)
	self.fDuration = self:GetAbility():GetSpecialValueFor( "duration" )
	self:SetStackCount(0)
	self.iPotionsToTrigger = self:GetAbility():GetSpecialValueFor("potions_to_trigger")
	self.iPotionsDrunk = 0
end

function modifier_alchemist_side_effect:IncrementPotionCount( iPotionCount )
	if IsServer() then
		local hParent = self:GetParent()
		self.iPotionsDrunk = self.iPotionsDrunk + iPotionCount
		if self.iPotionsDrunk >= self.iPotionsToTrigger then
			self.vPos = hParent:GetAbsOrigin()
			CreateModifierThinker(
				hParent,
				self:GetAbility(),
				"modifier_alchemist_side_effect_thinker",
				{ 
					duration = self.fDuration
				},
				self.vPos,
				hParent:GetTeamNumber(),
				false
			)
			self.iPotionsDrunk = self.iPotionsDrunk % self.iPotionsToTrigger
		end
		self:SetStackCount(self.iPotionsDrunk)

	end
end
