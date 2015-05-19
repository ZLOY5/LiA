function SpawnZombie(event)
	local caster = event.caster
	local ability = event.ability
	local level = ability:GetLevel()
	local unit_name = {"butcher_zombie_1","butcher_zombie_2","butcher_zombie_3"}

	if not ability.zombieCount then
		ability.zombieCount = 0
	end

	--точку спавна устанавливаем позади героя
	local spawnLoc = caster:GetAbsOrigin()-caster:GetForwardVector()*75 

	local zombie = CreateUnitByName(unit_name[level], spawnLoc, true, caster, nil, caster:GetTeamNumber())
	zombie:SetControllableByPlayer(caster:GetPlayerID(), true)
	zombie:MoveToNPC(caster)
	ability:ApplyDataDrivenModifier(caster, zombie, "modifier_butcher_zombie_death", nil) 
	
	ability.zombieCount = ability.zombieCount+1
	caster:SetModifierStackCount("modifier_butcher_zombie", ability, ability.zombieCount) 

	ability:StartCooldown(ability:GetCooldown(level))
	
end

function ZombieDeath(event)
	local caster = event.caster
	local ability = event.ability

	ability.zombieCount = ability.zombieCount-1
	caster:SetModifierStackCount("modifier_butcher_zombie", ability, ability.zombieCount) 
end
	
	
