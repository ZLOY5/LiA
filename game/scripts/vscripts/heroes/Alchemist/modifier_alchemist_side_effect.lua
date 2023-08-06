modifier_alchemist_side_effect = class({})

function modifier_alchemist_side_effect:IsHidden()
	return false
end

function modifier_alchemist_side_effect:IsPurgable()
	return false
end

function modifier_alchemist_side_effect:OnCreated(kv)
	self.fDuration = self:GetAbility():GetSpecialValueFor( "duration" )
	self.fChargeIncrementDelay = self:GetAbility():GetSpecialValueFor( "charge_delay" )
	self:SetStackCount(0)
	self.iPotionsToTrigger = self:GetAbility():GetSpecialValueFor("potions_to_trigger")
	self.iPotionsDrunk = 0
end

function modifier_alchemist_side_effect:IncrementPotionCount( iPotionCount )
	if IsServer() then
		Timers:CreateTimer({
            useGameTime = false,
            endTime = self.fChargeIncrementDelay,
            callback = function()
				local hParent = self:GetParent()
				self.iPotionsDrunk = self.iPotionsDrunk + iPotionCount
				if self.iPotionsDrunk >= self.iPotionsToTrigger then
					self.vPos = hParent:GetAbsOrigin()
					self.hSideEffectDummy = CreateUnitByName("dummy_unit_side_effect", self.vPos, false, hParent, hParent, hParent:GetTeam())
					self.hSideEffectDummy:SetControllableByPlayer(hParent:GetPlayerID(), true)
					self.hSideEffectDummy:AddNewModifier(hParent, self:GetAbility(), "modifier_alchemist_side_effect_thinker", {duration = self.fDuration})
					self.hSideEffectDummy:AddNewModifier(hParent, nil, "modifier_kill", {duration = self.fDuration})
					self.iPotionsDrunk = self.iPotionsDrunk % self.iPotionsToTrigger
				end
				self:SetStackCount(self.iPotionsDrunk)
            end
          })
	end
end
