
--[[Based on Pizzalol's datadriven Berserker's Call]]
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

function StopSound(keys)
	keys.caster:StopSound("Hero_NagaSiren.SongOfTheSiren")
end