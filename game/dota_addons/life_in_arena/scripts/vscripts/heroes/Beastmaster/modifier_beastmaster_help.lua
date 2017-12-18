modifier_beastmaster_help = class({})

function modifier_beastmaster_help:IsHidden()
	return true 
end

function modifier_beastmaster_help:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
	}
 
	return funcs
end

function modifier_beastmaster_help:OnDeath(params)
	if IsServer() then 
		if self:GetParent():PassivesDisabled() then
			return
		end
		if params.unit:GetPlayerOwnerID() == self:GetParent():GetPlayerOwnerID() and not params.unit:IsIllusion() and not params.unit:IsHero() then
			local heal_percent = self:GetAbility():GetSpecialValueFor("heal_percent")*0.01
			self:GetParent():Heal(params.unit:GetMaxHealth()*heal_percent, self:GetParent())
		end
	end
end
