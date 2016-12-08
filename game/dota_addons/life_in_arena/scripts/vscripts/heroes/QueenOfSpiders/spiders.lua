function spiderAutocast( keys )
	local caster = keys.caster
	local ability = keys.ability
	local playerID = caster:GetPlayerID()
	if ability:GetAutoCastState() then
		local autocast_radius = ability:GetSpecialValueFor( "autocast_radius" )
		--
		-- Name of the modifier to avoid casting the spell on targets that were already buffed
		local modifier = "modifier_infection"
		--
		--
		local table_target = FindUnitsInRadius(caster:GetTeam(),
									 caster:GetAbsOrigin(),
									 nil,
									 autocast_radius,
									 DOTA_UNIT_TARGET_TEAM_ENEMY,
									 DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
									 DOTA_UNIT_TARGET_FLAG_NONE,
									 FIND_ANY_ORDER,
									 false)
		--
		local randUnitI = RandomInt( 1, #table_target )
		local randUnit = table_target[randUnitI]
		--
		--print(randUnit)
		if randUnit ~= nil and not randUnit:HasModifier(modifier) then
			if ability:IsCooldownReady() and not caster:IsChanneling() then
				caster:CastAbilityOnTarget(randUnit, ability, playerID)
			end

		end
	end	
end


-- Auxiliar function that goes through every ability and item, checking for any ability being channelled
function IsChanneling ( hero )
	
	for abilitySlot=0,4 do
		local ability = hero:GetAbilityByIndex(abilitySlot)
		if ability ~= nil and ability:IsChanneling() then 
			return true
		end
	end

	for itemSlot=0,5 do
		local item = hero:GetItemInSlot(itemSlot)
		if item ~= nil and item:IsChanneling() then
			return true
		end
	end

	return false
end

function Infection(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	if target:TriggerSpellAbsorb(ability) then
		return 
	end
	target:EmitSound("Hero_Broodmother.SpawnSpiderlingsImpact")
	ability:ApplyDataDrivenModifier(caster, target, "modifier_infection", nil)
	ApplyDamage({victim = target, attacker = caster, damage = ability:GetSpecialValueFor("damage"), damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
end

function spiderCreate(keys)
	--
	local ability = keys.ability
	local caster = keys.caster --hero
	local durat = keys.durat
	local count = keys.count
	--
	local PID = caster:GetPlayerOwnerID()
	
    --local playerID =player:GetPlayerID()
	--local target = keys.target --enemy
	local target = keys.target_entities[1] --enemy
	--local targets = keys.target_entities
	local lvl = ability:GetLevel()-1
	local unitname
	if lvl == 0 then
		unitname = "queen_of_spiders_spider_1"
	end
	if lvl == 1 then
		unitname = "queen_of_spiders_spider_2"
	end
	if lvl == 2 then
		unitname = "queen_of_spiders_spider_3"
	end
	--
	for i=1,count do
		local cre = CreateUnitByName(unitname, target:GetAbsOrigin(), false, caster, caster, caster:GetTeam())
		cre:SetControllableByPlayer(PID, false)
		--
		cre:AddNewModifier(caster, nil, "modifier_kill", { duration = durat })
		cre:AddNewModifier(caster, nil, "modifier_phased", { duration = 0.03 })
		ResolveNPCPositions(cre:GetAbsOrigin(),65)
	end
	
end