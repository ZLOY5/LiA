modifier_dark_knight_dark_energy_zone_effect = class ({})



function modifier_dark_knight_dark_energy_zone_effect:IsHidden()
	return false
end

function modifier_dark_knight_dark_energy_zone_effect:IsPurgable()
	return false
end

function modifier_dark_knight_dark_energy_zone_effect:OnCreated(kv)
	self.mana_loss_reduction = self:GetAbility():GetSpecialValueFor("mana_loss_reduction")
	self.total_mana_spent = 0
end

function modifier_dark_knight_dark_energy_zone_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_SPENT_MANA,
	}
 
	return funcs
end

function modifier_dark_knight_dark_energy_zone_effect:OnSpentMana(params)
	if IsServer() then
		if params.unit == self:GetParent() then
			params.unit:GiveMana(params.cost)
			self.total_mana_spent = self.total_mana_spent + params.cost
		end
	end
end

function modifier_dark_knight_dark_energy_zone_effect:OnDestroy()
	if IsServer() then
		self:GetParent():ReduceMana(self.total_mana_spent)
	end
end