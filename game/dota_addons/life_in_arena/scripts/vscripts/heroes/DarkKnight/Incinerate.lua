--[[
	CHANGELIST
	09.01.2015 - Standized the variables
]]

--[[
	Author: kritth
	Date: 7.1.2015.
	Increasing stack after each hit
]]
function Incinerate( keys )
	-- Variables
	local caster = keys.caster
	local target = keys.target

	if caster:GetTeamNumber() == target:GetTeamNumber() then 
		return 
	end

	local ability = keys.ability
	local modifierName = "modifier_dark_knight_incinerate_target"
	local damageType = ability:GetAbilityDamageType()
	
	-- Necessary value from KV
	local duration = ability:GetLevelSpecialValueFor( "bonus_reset_time", ability:GetLevel() - 1 )
	local damage_per_stack = ability:GetLevelSpecialValueFor( "damage_per_stack", ability:GetLevel() - 1 )
	
	-- Check if unit already have stack
	if target:HasModifier( modifierName ) then
		local current_stack = target:GetModifierStackCount( modifierName, ability )
		
		-- Deal damage
		local damage_table = {
			victim = target,
			attacker = caster,
			damage = damage_per_stack * current_stack,
			damage_type = damageType,
			ability = ability
		}
		ApplyDamage( damage_table )
		
		ability:ApplyDataDrivenModifier( caster, target, modifierName, { Duration = duration } )
		target:SetModifierStackCount( modifierName, ability, current_stack + 1 )
	else
		ability:ApplyDataDrivenModifier( caster, target, modifierName, { Duration = duration } )
		target:SetModifierStackCount( modifierName, ability, 1 )
	end
end