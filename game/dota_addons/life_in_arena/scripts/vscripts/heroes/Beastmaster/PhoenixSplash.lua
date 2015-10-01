function PhoenixSplash(keys)
		-- Variables
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local radius_small = 25
	local radius_medium = 66 
	local radius_big = 25
	local target_exists = false
	local splash_damage_small = 1
	local splash_damage_medium = 0.5
	local splash_damage_big = 0.25
	
	-- Finding the units for each radius
	local splash_radius_small = FindUnitsInRadius(caster:GetTeam(), target:GetAbsOrigin() , nil, radius_small , DOTA_UNIT_TARGET_TEAM_ENEMY	, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false) 
	local splash_radius_medium = FindUnitsInRadius(caster:GetTeam() , target:GetAbsOrigin() , nil, radius_medium, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
	local splash_radius_big = FindUnitsInRadius(caster:GetTeam(), target:GetAbsOrigin() , nil, radius_big, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)

	-- Initializing the damage table
	local damage_table = {}
	damage_table.attacker = caster
	damage_table.damage_type = DAMAGE_TYPE_PHYSICAL
	damage_table.damage = caster:GetAttackDamage() * splash_damage_small
	damage_table.ability = ability


	--loop for doing the splash damage while ignoring the original target
	for i,v in ipairs(splash_radius_small) do
		if v ~= target then 
			damage_table.victim = v
			ApplyDamage(damage_table)
		end
	end
	--loop for doing the medium splash damage
	for i,v in ipairs(splash_radius_medium) do
		if v ~= target then
			--loop for checking if the found target is in the splash_radius_small
			for c,k in ipairs(splash_radius_small) do
				if v == k then
					target_exists = true
					break
				end
			end
			--if the target isn't in the splash_radius_small then do attack damage * splash_damage_medium
			if not target_exists then
				damage_table.damage = caster:GetAttackDamage() * splash_damage_medium
				damage_table.victim = v
				ApplyDamage(damage_table)
			--resets the target check	
			else
				target_exists = false
			end
		end
	end
	--loop for doing the damage if targets are found in the splash_damage_big but not in the splash_damage_medium
	for i,v in ipairs(splash_radius_big) do
		if v ~= target then
			--loop for checking if the found target is in the splash_radius_medium
			for c,k in ipairs(splash_radius_medium) do				
				if v == k then
					target_exists = true
					break
				end
			end
			if not target_exists then
				damage_table.damage = caster:GetAttackDamage() * splash_damage_big
				damage_table.victim = v
				ApplyDamage(damage_table)
			else
				target_exists = false
			end
		end
	end
end