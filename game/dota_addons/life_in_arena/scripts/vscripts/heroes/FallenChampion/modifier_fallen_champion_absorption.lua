modifier_fallen_champion_absorption = class ({})

function modifier_fallen_champion_absorption:IsHidden()
	return false
end 

--function modifier_fallen_champion_absorption:GetAttributes()
--	local attrs = {
--			MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE,
--			MODIFIER_ATTRIBUTE_PERMANENT,
--		}
--
--	return attrs
--end

--------------------------------------------------------------

function modifier_fallen_champion_absorption:OnCreated(params)
	local ability = self:GetAbility()
	if not ability.kill_stack then
		ability.kill_stack = 0
		ability.str_stack = 0
	end
	self:SetStackCount(ability.str_stack)
end

function modifier_fallen_champion_absorption:IsPurgable()
	return false
end

function modifier_fallen_champion_absorption:DeclareFunctions()
	local funcs = {
		--MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_EVENT_ON_DEATH,
	}
 
	return funcs
end


--function modifier_fallen_champion_absorption:GetModifierMoveSpeedBonus_Percentage(params)
--	return self:GetAbility():GetSpecialValueFor("ms_percentage")
--end

function modifier_fallen_champion_absorption:OnDeath(params)
	if IsServer() then
		if params.attacker == self:GetParent() and params.attacker:GetTeam() ~= params.unit:GetTeam() and not self:GetParent():IsIllusion() and not params.unit:IsIllusion() then
			local ability = self:GetAbility()
			if string.find(params.unit:GetUnitName(),"boss") or params.unit:IsHero() then
				-- сразу прибавляем силу
				local val = ability:GetSpecialValueFor("str_for_kill_boss_hero")
				ability.str_stack = ability.str_stack + val
				ability.kill_stack = 0
				self:GetParent():ModifyStrength(val)
				--print("ModifyStrength(val)=",val)
				self:SetStackCount(ability.str_stack)
				self:GetParent():CalculateStatBonus()
			else
				ability.kill_stack = ability.kill_stack + 1
				--print("ability.kill_stack=",ability.kill_stack)
				if ability.kill_stack >= ability:GetSpecialValueFor("kills_for_bonus_str") then
					ability.str_stack = ability.str_stack + 1
					ability.kill_stack = 0
					self:GetParent():ModifyStrength(1) -- для того чтобы добавленная ловкость была "белая"
					--print("ModifyStrength(1)")
					self:SetStackCount(ability.str_stack)
					self:GetParent():CalculateStatBonus()
				end
				--
			end
		end
	end
end