modifier_shaman_resourcefulness = class ({})

function modifier_shaman_resourcefulness:IsHidden()
	return false
end 

--function modifier_shaman_resourcefulness:GetAttributes()
--	local attrs = {
--			MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE,
--			MODIFIER_ATTRIBUTE_PERMANENT,
--		}
--
--	return attrs
--end

--------------------------------------------------------------

function modifier_shaman_resourcefulness:IsPurgable()
	return false
end

function modifier_shaman_resourcefulness:IsBuff()
	return true
end

function modifier_shaman_resourcefulness:RemoveOnDeath()
	return false
end


function modifier_shaman_resourcefulness:OnCreated(params)
	local ability = self:GetAbility()
	if not ability.kill_stack then
		ability.kill_stack = 0
		ability.agility_stack = 0
	end
	self:SetStackCount(ability.agility_stack)
end

function modifier_shaman_resourcefulness:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_EVENT_ON_DEATH,
	}
 
	return funcs
end


function modifier_shaman_resourcefulness:GetModifierMoveSpeedBonus_Percentage(params)
	return self:GetAbility():GetSpecialValueFor("ms_percentage")
end

function modifier_shaman_resourcefulness:OnDeath(params)
	if IsServer() then
		if params.attacker == self:GetParent() and params.attacker:GetTeam() ~= params.unit:GetTeam() and not self:GetParent():IsIllusion() and not params.unit:IsIllusion() then
			local ability = self:GetAbility()
			ability.kill_stack = ability.kill_stack + 1
			if ability.kill_stack >= ability:GetSpecialValueFor("kills_for_bonus_agility") then
				ability.agility_stack = ability.agility_stack + 1
				ability.kill_stack = 0
				self:GetParent():ModifyAgility(1) -- для того чтобы добавленная ловкость была "белая"
				self:GetParent():CalculateStatBonus()
				self:SetStackCount(ability.agility_stack)
			end
		end
	end
end