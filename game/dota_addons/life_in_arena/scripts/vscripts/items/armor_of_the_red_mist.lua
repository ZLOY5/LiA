
--[[Based on Pizzalol's datadriven Berserker's Call]]

function ApplyTaunt( keys )
	local ability = keys.ability
	local target = keys.target
	local caster = keys.caster
	local duration = ability:GetSpecialValueFor("duration")

	if string.find(target:GetUnitName(),"megaboss") or target:IsHero() then
		ability:ApplyDataDrivenModifier(caster,target,"modifier_item_lia_armor_of_the_red_mist_taunt",{duration = duration/2})
	else
		ability:ApplyDataDrivenModifier(caster,target,"modifier_item_lia_armor_of_the_red_mist_taunt",{duration = duration})
	end

	
end

function Taunt( keys )
	local caster = keys.caster
	local target = keys.target

	-- Clear the force attack target
	target:SetForceAttackTarget(nil)

	-- Give the attack order if the caster is alive
	-- otherwise forces the target to sit and do nothing
	if caster:IsAlive() then
		local order = 
		{
			UnitIndex = target:entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
			TargetIndex = caster:entindex()
		}

		ExecuteOrderFromTable(order)
	else
		target:Stop()
	end

	-- Set the force attack target to be the caster
	target:SetForceAttackTarget(caster)
end

-- Clears the force attack target upon expiration
function TauntEnd( keys )
	local target = keys.target

	target:SetForceAttackTarget(nil)
	target:MoveToPositionAggressive(target:GetAbsOrigin()+target:GetForwardVector()*50)
end