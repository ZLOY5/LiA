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
	if IsServer() then
		CustomNetTables:SetTableValue( "custom_modifier_state", string.format( "%d", self:GetParent():GetEntityIndex() ), { total_mana_spent = self.total_mana_spent } )
	end
end

function modifier_dark_knight_dark_energy_zone_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_SPENT_MANA,
		MODIFIER_PROPERTY_TOOLTIP,
	}
 
	return funcs
end

function modifier_dark_knight_dark_energy_zone_effect:GetEffectName()
	return "particles/custom/dark_knight/dark_knight_dark_energy_zone_buff.vpcf"
end

function modifier_dark_knight_dark_energy_zone_effect:GetEffectAttachType()
	return PATTACH_CUSTOMORIGIN_FOLLOW
end

function modifier_dark_knight_dark_energy_zone_effect:OnSpentMana(params)
	if IsServer() then
		if params.unit == self:GetParent() then
			params.unit:GiveMana(params.cost)
			self.total_mana_spent = self.total_mana_spent + params.cost
			CustomNetTables:SetTableValue( "custom_modifier_state", string.format( "%d", self:GetParent():GetEntityIndex() ), { total_mana_spent = self.total_mana_spent } )
		end
	end
end

function modifier_dark_knight_dark_energy_zone_effect:OnDestroy()
	if IsServer() then
		self:GetParent():ReduceMana(self.total_mana_spent)
		if self.total_mana_spent > 0 then
			EmitSoundOn("Hero_Abaddon.AphoticShield.Destroy", self:GetParent())
			PopupNumbers(self:GetParent():GetPlayerOwner() ,self:GetParent(), "mana_loss", Vector(77,230,255), 3, self.total_mana_spent, POPUP_SYMBOL_PRE_MINUS, nil)
		end
	end
end

function modifier_dark_knight_dark_energy_zone_effect:GetCustomManaLossReductionPercentage()
	return self.mana_loss_reduction
end

function modifier_dark_knight_dark_energy_zone_effect:OnTooltip()
	local netTable = CustomNetTables:GetTableValue( "custom_modifier_state", string.format( "%d", self:GetParent():GetEntityIndex() ) )
	return netTable.total_mana_spent
end