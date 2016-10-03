function BlockDamage_PhysicalPreArmor(attack_damage,damage_type,victim,attacker,inflictor) 
	local blocked_damage = 0 
	local newDamage = attack_damage

	if victim:HasModifier("modifier_ancient_priestess_ritual_protection") then 
		local blocked = victim:FindModifierByName("modifier_ancient_priestess_ritual_protection"):GetBlockDamage(newDamage)
		blocked_damage = blocked_damage + blocked
		newDamage = newDamage - blocked
	end

	if newDamage <= 0 then 
		return attack_damage
	end

	if victim:HasModifier("modifier_archmage_magic_barrier") then 
		local blocked = victim:FindModifierByName("modifier_archmage_magic_barrier"):GetBlockedDamage(newDamage)
		blocked_damage = blocked_damage + blocked
		newDamage = newDamage - blocked
	end

	if newDamage <= 0 then 
		return attack_damage
	end

	if victim:HasModifier("modifier_ancient_priestess_mana_shield") then 
		local blocked = victim:FindModifierByName("modifier_ancient_priestess_mana_shield"):GetBlockDamage(newDamage)
		blocked_damage = blocked_damage + blocked
		newDamage = newDamage - blocked
	end

	if newDamage <= 0 then 
		return attack_damage
	end

	if victim:HasModifier("modifier_ancient_priestess_spirit_link") then 
		if victim.spiritLink_damage then 
			victim.spiritLink_damage = nil
		else
			--print("Link Damage")
			local link_blocked = victim:FindModifierByName("modifier_ancient_priestess_spirit_link"):LinkDamage(newDamage,damage_type,attacker,inflictor)
			blocked_damage = blocked_damage + link_blocked
			newDamage = newDamage - link_blocked
		end
	end

	if newDamage <= 0 then 
		return attack_damage
	end
	return blocked_damage
end


function LiA:FilterDamage( filterTable )
	--for k, v in pairs( filterTable ) do
	--	print("Damage: " .. k .. " " .. tostring(v) )
	--end
	local victim_index = filterTable["entindex_victim_const"]
	local attacker_index = filterTable["entindex_attacker_const"]
	local inflictor_index = filterTable["entindex_inflictor_const"] or -1
	--print(inflictor_index)
	if not victim_index or not attacker_index then
		return true
	end

	local victim = EntIndexToHScript( victim_index )
	local attacker = EntIndexToHScript( attacker_index )
	local inflictor = EntIndexToHScript( inflictor_index )
	--print(inflictor)
	local damagetype = filterTable["damagetype_const"]

	-- Physical attack damage filtering
	if damagetype == DAMAGE_TYPE_PHYSICAL then
		local original_damage = filterTable["damage"] --Post reduction
		
		local armor = victim:GetPhysicalArmorValue()
		local damage_reduction = ((armor)*0.06) / (1+0.06*(armor))

		-- If there is an inflictor, the damage came from an ability
		local attack_damage = original_damage / ( 1 - damage_reduction ) 
	--print("		inflictor = ", inflictor)
		--[[if inflictor then
			--Remake the full damage to apply our custom handling
			attack_damage = original_damage / ( 1 - damage_reduction )
			--print(original_damage,"=",attack_damage,"*",1-damage_reduction)
		else
			attack_damage = attacker:GetAttackDamage() -- баг с модификаторами блокирующими часть урона
		end]]
		--print("phys")
		-- Adjust if the damage comes from splash
		if not inflictor then
			if victim.damage_from_splash then
				--print("DAMAGE FROM SPLASH",victim:GetName(),attacker:GetName(),victim.damage_from_splash)
				attack_damage = victim.damage_from_splash
				victim.damage_from_splash = nil
			elseif HasSplashAttack(attacker) then
				--print("SPLASH",victim:GetName(),attacker:GetName(),attack_damage)
				SplashAttack(attack_damage, attacker, victim)
				--print("SPLASH END")
			end
		end

		local attack_type  = attacker:GetAttackType()
		local armor_type = victim:GetArmorType()
		local multiplier = attacker:GetAttackFactorAgainstTarget(victim)
		--print("		attack_type = ", attack_type)
		--print("		armor_type = ", armor_type)
		--print("		multiplier = ", multiplier)
		--print(original_damage,"=",attack_damage,"*",1-damage_reduction)
		
		local damage = attack_damage -- - BlockDamage_PhysicalPreArmor(attack_damage,damagetype,victim,attacker,inflictor)

		damage = ( damage * (1 - damage_reduction)) * multiplier

		local damage = damage - BlockDamage_PhysicalPreArmor(damage,damagetype,victim,attacker,inflictor) --после брони теперь все говно
		
		--if attacker:GetUnitName() == "npc_dummy_blank" then
		--	print("			original_damage = ",original_damage)
		--	print("			attack_damage = ",attack_damage)
		--	print("			damage_reduction = ",damage_reduction)
		--	print("			damage = ",damage)
			
		--end

		-- Extra rules for certain ability modifiers
		if victim:HasModifier("modifier_brain_storm_decrepify") or victim:HasModifier("modifier_hermit_decrepify")
			or victim:HasModifier("modifier_illusionist_mastery_of_illusions")
		then
			if attack_type ~= "magic" then
				damage = 0
			else
				damage = damage * 1.5
			end
		end
		if victim:HasModifier("modifier_ancient_shield_defend") and attack_type == "pierce" then
			-- Снижение урона от дальних атак у Рыцаря
			local b_abil = victim:FindAbilityByName("knight_ancient_shield")
			local koef = b_abil:GetSpecialValueFor("piercing_damage_reduction")
			damage = damage * koef/100
		end
		
		-- Reassign the new damage
		filterTable["damage"] = damage
	
	-- Magic damage filtering
	elseif damagetype == DAMAGE_TYPE_MAGICAL then
		local damage = filterTable["damage"] --Pre reduction

		damage = damage - BlockDamage_PhysicalPreArmor(damage,damagetype,victim,attacker,inflictor)
		-- Reassign the new damage
		filterTable["damage"] = damage
	elseif damagetype == DAMAGE_TYPE_PURE then
		local damage = filterTable["damage"]
		damage = damage - BlockDamage_PhysicalPreArmor(damage,damagetype,victim,attacker,inflictor)
		-- Reassign the new damage
		filterTable["damage"] = damage
	end

	return true
end

function SplashAttack( attack_damage, attacker, victim )
	local target = victim

	local small_radius = GetSmallSplashRadius(attacker)  --QArea in war3
    local small_damage = attack_damage * GetSmallSplashDamage(attacker) --QFact in war3

	local medium_radius = GetMediumSplashRadius(attacker) --HArea
    local medium_damage = attack_damage * GetMediumSplashDamage(attacker) --HFact

	local full_radius = GetFullDamageSplashRadius(attacker) --FArea, full damage radius

	local targets_full_damage_radius = FindUnitsInRadius(attacker:GetTeamNumber(), 
														target:GetAbsOrigin(), 
														nil, 
														full_radius ,
														DOTA_UNIT_TARGET_TEAM_ENEMY, 
														DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
														DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
														FIND_ANY_ORDER, 
														false)
	
    --DebugDrawCircle(target:GetAbsOrigin(), Vector(255,0,0), 100, full_radius, true, 3)
    for _,v in pairs(targets_full_damage_radius) do
        if v ~= attacker and v ~= target then
        	v.damage_from_splash = attack_damage
        	v.splash_full_damaged = true
            ApplyDamage({ victim = v, attacker = attacker, damage = attack_damage, damage_type = DAMAGE_TYPE_PHYSICAL})
        end
    end

    local targets_medium_radius = FindUnitsInRadius(attacker:GetTeamNumber(), 
														target:GetAbsOrigin(), 
														nil, 
														medium_radius ,
														DOTA_UNIT_TARGET_TEAM_ENEMY, 
														DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
														DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
														FIND_ANY_ORDER, 
														false)

    --DebugDrawCircle(target:GetAbsOrigin(), Vector(255,65,0), 100, medium_radius, true, 3)
    for _,v in pairs(targets_medium_radius) do
        if v ~= attacker and v ~= target and not v.splash_full_damaged then
        	v.damage_from_splash = medium_damage
        	v.splash_medium_damaged = true
            ApplyDamage({ victim = v, attacker = attacker, damage = medium_damage, damage_type = DAMAGE_TYPE_PHYSICAL})
        end
    end

    
    local targets_small_radius = FindUnitsInRadius(attacker:GetTeamNumber(), 
														target:GetAbsOrigin(), 
														nil, 
														small_radius ,
														DOTA_UNIT_TARGET_TEAM_ENEMY, 
														DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
														DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
														FIND_ANY_ORDER, 
														false)

    --DebugDrawCircle(target:GetAbsOrigin(), Vector(255,127,0), 100, small_radius, true, 3)
    for _,v in pairs(targets_small_radius) do
        if v ~= attacker and v ~= target and not v.splash_medium_damaged and not v.splash_full_damaged then
        	v.damage_from_splash = small_damage
            ApplyDamage({ victim = v, attacker = attacker, damage = small_damage, damage_type = DAMAGE_TYPE_PHYSICAL})
        end
    end

    for _,v in pairs(targets_full_damage_radius) do
    	v.splash_full_damaged = nil
    end

    for _,v in pairs(targets_medium_radius) do
    	v.splash_medium_damaged = nil
    end

end

function CDOTA_BaseNPC:GetAttackType()
    return GameRules.UnitKV[self:GetUnitName()]["AttackType"] or "normal"
end

-- Returns a string with the wc3 armor name
function CDOTA_BaseNPC:GetArmorType()
    return GameRules.UnitKV[self:GetUnitName()]["ArmorType"] or "normal"
end

function CDOTA_BaseNPC:GetAttackFactorAgainstTarget( unit )
    local attack_type = self:GetAttackType()
    local armor_type = unit:GetArmorType()
    local damageTable = GameRules.Damage
    return damageTable[attack_type] and damageTable[attack_type][armor_type] or 1
end

-- Searches for "AttacksEnabled", false by omission
function HasSplashAttack( unit )
	local unitName = unit:GetUnitName()
	local unit_table = GameRules.UnitKV[unitName]
	
	if unit_table then
		if unit_table["SplashAttack"] and unit_table["SplashAttack"] == 1 then
			return true
		end
	end

	return false
end

function GetFullDamageSplashRadius( unit ) --FArea in war3
	local unitName = unit:GetUnitName()
	local unit_table = GameRules.UnitKV[unitName]
	if unit_table["SplashFullDamageRadius"] then
		return unit_table["SplashFullDamageRadius"]
	end

	return 0
end

function GetMediumSplashRadius( unit ) --HArea in war3
	local unitName = unit:GetUnitName()
	local unit_table = GameRules.UnitKV[unitName]
	if unit_table["SplashMediumRadius"] then
		return unit_table["SplashMediumRadius"]
	end

	return 0
end

function GetSmallSplashRadius( unit ) --QArea in war3
	local unitName = unit:GetUnitName()
	local unit_table = GameRules.UnitKV[unitName]
	if unit_table["SplashSmallRadius"] then
		return unit_table["SplashSmallRadius"]
	end

	return 0
end

function GetMediumSplashDamage( unit ) --HFact in war3
	local unitName = unit:GetUnitName()
	local unit_table = GameRules.UnitKV[unitName]
	if unit_table["SplashMediumDamage"] then
		return unit_table["SplashMediumDamage"]
	end

	return 0
end

function GetSmallSplashDamage( unit ) --QFact in war3
	local unitName = unit:GetUnitName()
	local unit_table = GameRules.UnitKV[unitName]
	if unit_table["SplashSmallDamage"] then
		return unit_table["SplashSmallDamage"]
	end
	
	return 0
end