modifier_staff_of_life_effect = class ({})


function modifier_staff_of_life_effect:IsHidden()
	return false
end

function modifier_staff_of_life_effect:IsPurgable()
	return true
end

function modifier_staff_of_life_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_TOOLTIP,
	}
 
	return funcs
end

function modifier_staff_of_life_effect:GetEffectName()
	return "particles/custom/items/staff_of_life_buff.vpcf"
end

function modifier_staff_of_life_effect:GetEffectAttachType()
	return PATTACH_CUSTOMORIGIN_FOLLOW
end

function modifier_staff_of_life_effect:OnCreated()
	if IsServer() then
		self.restore_limit = self:GetAbility():GetSpecialValueFor("restore_limit")
		CustomNetTables:SetTableValue( "custom_modifier_state", string.format( "%d", self:GetParent():GetEntityIndex() ), { restore_amount = self.restore_limit } )
	end
end


function modifier_staff_of_life_effect:OnTakeDamage(params)
	if IsServer() then
		if params.attacker:GetTeam() ~= params.unit:GetTeam() and params.unit == self:GetParent() then

			local damage = params.damage

			if damage == 0 then
				return
			end

			local damage_type = params.damage_type

			ApplyDamage(
			{
				victim = params.attacker, 
				attacker = params.unit, 
				damage = damage, 
				damage_type = damage_type,
				damage_flags = DOTA_DAMAGE_FLAG_REFLECTION,
				ability = self:GetAbility()
			})

			if self.restore_limit > damage then
				self.restore_limit = self.restore_limit - damage
				params.unit:Heal(damage, params.unit)
				CustomNetTables:SetTableValue( "custom_modifier_state", string.format( "%d", self:GetParent():GetEntityIndex() ), { restore_amount = self.restore_limit } )
			else
				params.unit:Heal(self.restore_limit, params.unit)
				self:Destroy()
			end

			self.staffOfLightHealParticle = ParticleManager:CreateParticle("particles/custom/items/staff_of_life_heal.vpcf",PATTACH_WORLDORIGIN,self:GetParent())
			ParticleManager:SetParticleControl( self.staffOfLightHealParticle, 0, self:GetParent():GetAbsOrigin() )
		end
	end
end

function modifier_staff_of_life_effect:OnTooltip(params)
	local netTable = CustomNetTables:GetTableValue( "custom_modifier_state", string.format( "%d", self:GetParent():GetEntityIndex() ) )
	return netTable.restore_amount
end

