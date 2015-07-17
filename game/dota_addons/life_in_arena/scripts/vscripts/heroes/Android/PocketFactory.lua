--[[
	Author: Noya https://github.com/MNoya/DotaCraft/blob/master/game/dota_addons/dotacraft/scripts/vscripts/heroes/tinker/pocket_factory.lua
	Date: 03.02.2015.
	Creates a building, adds ability to spawn units every at an interval which decreases with engineering_upgrade levels
]]
function BuildPocketFactory( event )
	-- Variables
	local caster = event.caster
	local ability = event.ability
	local point = event.target_points[1]
	local factory_duration =  ability:GetLevelSpecialValueFor( "factory_duration" , ability:GetLevel() - 1  )
	local ability_level = ability:GetLevel()
	local building_name = "android_pocket_factory_building"..ability_level

	local dummy = CreateUnitByName("npc_dummy_blank", point, false, caster, nil, caster:GetTeam())
	dummy:SetHullRadius(160) 
	FindClearSpaceForUnit(dummy, point, false)
	
	-- Create the building, set to time out after a duration
	caster.pocket_factory = CreateUnitByName(building_name, dummy:GetAbsOrigin(), false, caster, caster, caster:GetTeam())
	caster.pocket_factory:SetControllableByPlayer(caster:GetPlayerID(), true)

	dummy:RemoveSelf()

	caster.pocket_factory:AddNewModifier(caster, nil, "modifier_kill", {duration = factory_duration})
	caster.pocket_factory:RemoveModifierByName("modifier_invulnerable")
	caster.pocket_factory.no_corpse = true
	--Timers:CreateTimer(0.03, function() caster.pocket_factory:SetAbsOrigin(point) end)

	-- Add the ability and set its level
	caster.pocket_factory:AddAbility("android_pocket_factory_spawn_goblin")
	local spawn_ability = caster.pocket_factory:FindAbilityByName("android_pocket_factory_spawn_goblin")
	spawn_ability:SetLevel(ability_level)

end

-- When the building is created, check level of engineering and start spawning every interval
function StartGoblinSpawn( event )
	local caster = event.caster
	local hero = caster:GetPlayerOwner():GetAssignedHero()
	local player = hero:GetPlayerID()
	local ability = event.ability
	local ability_level = ability:GetLevel()
	local spawn_ratio = ability:GetLevelSpecialValueFor( "spawn_ratio" , ability:GetLevel() - 1  )
	local goblin_duration = ability:GetLevelSpecialValueFor( "goblin_duration" , ability:GetLevel() - 1  )
	local unit_name = "android_clockwerk_goblin"..ability_level
	local goblin_ability_name = "android_clockwerk_goblin_kaboom"
	local goblin_ability_bash = "android_pocket_factory_spawn_goblin"..ability_level

	-- Display the spawn ability as cooling down, this is purely cosmetic but helps showing the interval
	ability:StartCooldown(spawn_ratio)

	-- Start the repeated spawn
	Timers:CreateTimer(spawn_ratio, function()

		if caster and IsValidEntity(caster) and caster:IsAlive() then
			-- Start another cooldown
			ability:StartCooldown(spawn_ratio)
			-- Create the unit, making it controllable by the building owner, and time out after a duration.
			local goblin = CreateUnitByName(unit_name, caster:GetOrigin(), true, hero, hero, caster:GetTeamNumber())
			goblin:SetControllableByPlayer(player, true)
			goblin:AddNewModifier(caster, nil, "modifier_kill", {duration = goblin_duration})

			
			-- Add the ability and set its level to the main ability level
			goblin:AddAbility(goblin_ability_name)
			local goblin_ability = goblin:FindAbilityByName(goblin_ability_name)
			goblin_ability:SetLevel(ability_level)
			local goblin_ability = goblin:FindAbilityByName(goblin_ability_bash)
			goblin_ability:SetLevel(1)

			-- Spawn sound
			goblin:EmitSound("Hero_Tinker.March_of_the_Machines.Cast")

			return spawn_ratio
		end
	end)

end