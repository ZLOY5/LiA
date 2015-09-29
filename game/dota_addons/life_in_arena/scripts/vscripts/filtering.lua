
-- cr. MNoya
require('LiA')

ATTACK_TYPES = {
	["DOTA_COMBAT_CLASS_ATTACK_BASIC"] = "normal",
	["DOTA_COMBAT_CLASS_ATTACK_PIERCE"] = "pierce",
	["DOTA_COMBAT_CLASS_ATTACK_SIEGE"] = "siege",
	["DOTA_COMBAT_CLASS_ATTACK_LIGHT"] = "chaos",
	["DOTA_COMBAT_CLASS_ATTACK_HERO"] = "hero",
	["DOTA_COMBAT_CLASS_ATTACK_MAGIC"] = "magic",
}

ARMOR_TYPES = {
	["DOTA_COMBAT_CLASS_DEFEND_SOFT"] = "unarmored",
	["DOTA_COMBAT_CLASS_DEFEND_WEAK"] = "light",
	["DOTA_COMBAT_CLASS_DEFEND_BASIC"] = "medium",
	["DOTA_COMBAT_CLASS_DEFEND_STRONG"] = "heavy",
	["DOTA_COMBAT_CLASS_DEFEND_STRUCTURE"] = "fortified",
	["DOTA_COMBAT_CLASS_DEFEND_HERO"] = "hero",
}

function GetDamageForAttackAndArmor( attack_type, armor_type )
--[[
http://classic.battle.net/war3/basics/armorandweapontypes.shtml
        Unarm   Light   Medium  Heavy   Fort   Hero   
Normal  100%    100%    150%    100%    70%    100%   
Pierce  150%    200%    75%     100%    35%    50%    
Siege   150%    100%    50%     100%    150%   50%      
Chaos   100%    100%    100%    100%    100%   100%     
Hero    100%    100%    100%    100%    50%    100%
-- Custom Attack Types
Magic   100%    125%    75%     200%    35%    50%
Spells  100%    100%    100%    100%    100%   70%  

	НЕСТАНДАРТНАЯ ТАБЛИЦА УРОНА В ЖНА В ВАРЕ3
		броня		легкая	средняя	тяжелая	укрепленная	обычная герой	божественная	без
	атака
	сила тьмы:  	100		100		100		100			100		130		100				100
	артилерия:		100		50		100		150			100		50		5				150
	герой:			100		100		100		50			100		110		5				100
	дальний бой:	200		75		100		35			100		70		5				150
	магия:			125		75		200		35			100		90		5				100
	обычный:		100		150		100		70			100		100		5				100
	заклинания		100		100		100		100			100		80		5				100


]]
	if attack_type == "normal" then
		if armor_type == "unarmored" then
			return 1
		elseif armor_type == "light" then
			return 1
		elseif armor_type == "medium" then
			return 1.5
		elseif armor_type == "heavy" then
			return 1 --1.25 in dota
		elseif armor_type == "fortified" then
			return 0.7
		elseif armor_type == "hero" then
			return 1 --0.75 in dota
		end

	elseif attack_type == "pierce" then
		if armor_type == "unarmored" then
			return 1.5
		elseif armor_type == "light" then
			return 2
		elseif armor_type == "medium" then
			return 0.75
		elseif armor_type == "heavy" then
			return 1 --0.75 in dota
		elseif armor_type == "fortified" then
			return 0.35
		elseif armor_type == "hero" then
			return 0.7 --0.5
		end

	elseif attack_type == "siege" then
		if armor_type == "unarmored" then
			return 1.5 --1 in dota
		elseif armor_type == "light" then
			return 1
		elseif armor_type == "medium" then
			return 0.5
		elseif armor_type == "heavy" then
			return 1 --1.25 in dota
		elseif armor_type == "fortified" then
			return 1.5
		elseif armor_type == "hero" then
			return 0.5 --0.75 in dota
		end

	elseif attack_type == "chaos" then
		if armor_type == "unarmored" then
			return 1
		elseif armor_type == "light" then
			return 1
		elseif armor_type == "medium" then
			return 1
		elseif armor_type == "heavy" then
			return 1
		elseif armor_type == "fortified" then
			return 1 --0.4 in Dota
		elseif armor_type == "hero" then
			return 1.3 --1
		end

	elseif attack_type == "hero" then
		if armor_type == "unarmored" then
			return 1
		elseif armor_type == "light" then
			return 1
		elseif armor_type == "medium" then
			return 1
		elseif armor_type == "heavy" then
			return 1
		elseif armor_type == "fortified" then
			return 0.5
		elseif armor_type == "hero" then
			return 1.1 --1
		end

	elseif attack_type == "magic" then
		if armor_type == "unarmored" then
			return 1
		elseif armor_type == "light" then
			return 1.25
		elseif armor_type == "medium" then
			return 0.75
		elseif armor_type == "heavy" then
			return 2
		elseif armor_type == "fortified" then
			return 0.35
		elseif armor_type == "hero" then
			return 0.9 --0.5
		end
	end
	return 1
end

-- Returns a string with the wc3 damage name
function GetAttackType( unit )
	if unit and IsValidEntity(unit) then
		local unitName = unit:GetUnitName()
		if GameRules.UnitKV[unitName] and GameRules.UnitKV[unitName]["CombatClassAttack"] then
			local attack_string = GameRules.UnitKV[unitName]["CombatClassAttack"]
			return ATTACK_TYPES[attack_string]
		elseif unit:IsHero() then
			return "hero"
		end
	end
	return 0
end

-- Returns a string with the wc3 armor name
function GetArmorType( unit )
	if unit and IsValidEntity(unit) then
		local unitName = unit:GetUnitName()
		if GameRules.UnitKV[unitName] and GameRules.UnitKV[unitName]["CombatClassDefend"] then
			local armor_string = GameRules.UnitKV[unitName]["CombatClassDefend"]
			return ARMOR_TYPES[armor_string]
		elseif unit:IsHero() then
			return "hero"
		end
	end
	return 0
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

function GetMediumSplashRadius( unit )
	local unitName = unit:GetUnitName()
	local unit_table = GameRules.UnitKV[unitName]
	if unit_table["SplashMediumRadius"] then
		return unit_table["SplashMediumRadius"]
	end
	return 0
end

function GetSmallSplashRadius( unit )
	local unitName = unit:GetUnitName()
	local unit_table = GameRules.UnitKV[unitName]
	if unit_table["SplashSmallRadius"] then
		return unit_table["SplashSmallRadius"]
	end
	return 0
end

function GetMediumSplashDamage( unit )
	local unitName = unit:GetUnitName()
	local unit_table = GameRules.UnitKV[unitName]
	if unit_table["SplashMediumDamage"] then
		return unit_table["SplashMediumDamage"]
	end
	return 0
end

function GetSmallSplashDamage( unit )
	local unitName = unit:GetUnitName()
	local unit_table = GameRules.UnitKV[unitName]
	if unit_table["SplashSmallDamage"] then
		return unit_table["SplashSmallDamage"]
	end
	return 0
end

function LiA:FilterDamage( filterTable )
	--for k, v in pairs( filterTable ) do
	--	print("Damage: " .. k .. " " .. tostring(v) )
	--end
	local victim_index = filterTable["entindex_victim_const"]
	local attacker_index = filterTable["entindex_attacker_const"]
	if not victim_index or not attacker_index then
		return true
	end

	local victim = EntIndexToHScript( victim_index )
	local attacker = EntIndexToHScript( attacker_index )
	local damagetype = filterTable["damagetype_const"]

	-- Physical attack damage filtering
	if damagetype == DAMAGE_TYPE_PHYSICAL then
		local original_damage = filterTable["damage"] --Post reduction
		local inflictor = filterTable["entindex_inflictor_const"]

		local armor = victim:GetPhysicalArmorValue()
		local damage_reduction = ((armor)*0.06) / (1+0.06*(armor))

		-- If there is an inflictor, the damage came from an ability
		local attack_damage
		if inflictor then
			--Remake the full damage to apply our custom handling
			attack_damage = original_damage / ( 1 - damage_reduction )
			--print(original_damage,"=",attack_damage,"*",1-damage_reduction)
		else
			attack_damage = attacker:GetAttackDamage()
		end
	
		-- Adjust if the damage comes from splash
		if victim.damage_from_splash then
			attack_damage = victim.damage_from_splash
			victim.damage_from_splash = nil
		elseif HasSplashAttack(attacker) then
			SplashAttack(attack_damage, attacker, victim)
		end

		local attack_type  = GetAttackType( attacker )
		local armor_type = GetArmorType( victim )
		local multiplier = GetDamageForAttackAndArmor(attack_type, armor_type)

		local damage = ( attack_damage * (1 - damage_reduction)) * multiplier

		-- Extra rules for certain ability modifiers
		-- modifier_defend (50% less damage from Piercing attacks)
		--if victim:HasModifier("modifier_defend") and attack_type == "pierce" then
		--	print("Defend reduces this piercing attack to 50%")
		--	damage = damage * 0.5

		-- modifier_elunes_grace (Piercing attacks to 65%)
		--elseif victim:HasModifier("modifier_elunes_grace") and attack_type == "pierce" then
		--	print("Elunes Grace reduces this piercing attack to 65%")
		--	damage = damage * 0.65
		
		-- modifier_possession_caster (All attacks to 166%)
		--elseif victim:HasModifier("modifier_possession_caster") then
		--	damage = damage * 1.66
		--end

		--print("Damage ("..attack_type.." vs "..armor_type.." armor ["..math.floor(armor).."]): ("  .. attack_damage .. " * "..1-damage_reduction..") * ".. multiplier.. " = " .. damage )
		
		-- Reassign the new damage
		filterTable["damage"] = damage
	
	-- Magic damage filtering
	elseif damagetype == DAMAGE_TYPE_MAGICAL then
		local inflictor = filterTable["entindex_inflictor_const"]
		local damage = filterTable["damage"] --Pre reduction

		-- Extra rules for certain ability modifiers
		-- modifier-anti_magic_shell (Absorbs 300 magic damage)
		--[[if victim:HasModifier("modifier_anti_magic_shell") then
			local absorbed = 0
			local absorbed_already = victim.anti_magic_shell_absorbed

			if damage+absorbed_already < 300 then
				absorbed = damage
				victim.anti_magic_shell_absorbed = absorbed_already + damage
			else
				-- Absorb up to the limit and end
				absorbed = 300 - absorbed_already
				victim:RemoveModifierByName("modifier_anti_magic_shell")
				victim.anti_magic_shell_absorbed = nil
			end

			if victim.anti_magic_shell_absorbed then
				print("Anti-Magic Shell Absorbed "..absorbed.." damage from an instace of "..damage.." ("..victim.anti_magic_shell_absorbed.." so far)")
			else
				print("Anti-Magic Shell Absorbed "..absorbed.." damage from an instace of "..damage.." and ended")
			end
			damage = damage - absorbed
		end	

		if damage ~= filterTable["damage"] then
			print("Magic Damage reduced: was ".. filterTable["damage"].." - dealt "..damage )
		end]]
		
		-- Reassign the new damage
		filterTable["damage"] = damage

	end

	-- Cheat code host only
  	--[[if GameRules.WhosYourDaddy then
  		local victimID = EntIndexToHScript(victim_index):GetPlayerOwnerID()
  		if victimID == 0 then
  			filterTable["damage"] = 0
  		end
  	end]]

	return true
end

function SplashAttack( attack_damage, attacker, victim )
	local target = victim
	local medium_radius = GetMediumSplashRadius(attacker)
    local medium_damage = attack_damage * GetMediumSplashDamage(attacker)

    local small_radius = GetSmallSplashRadius(attacker)
    local small_damage = attack_damage * GetSmallSplashDamage(attacker)

    --print("Attacked for "..attack_damage.." - Splashing "..medium_damage.." damage in "..medium_radius.." (medium radius) and "..small_damage.." in "..small_radius.." (small radius)")

    local targets_medium_radius = FindAllUnitsInRadius(target, medium_radius)
    --DebugDrawCircle(target:GetAbsOrigin(), Vector(255,0,0), 100, medium_radius, true, 3)
    for _,v in pairs(targets_medium_radius) do
        if v ~= attacker and v ~= target then
        	v.damage_from_splash = medium_damage
            ApplyDamage({ victim = v, attacker = attacker, damage = medium_damage, damage_type = DAMAGE_TYPE_PHYSICAL})
        end
    end

    local targets_small_radius = FindAllUnitsInRadius(target, small_radius)
    --DebugDrawCircle(target:GetAbsOrigin(), Vector(255,0,0), 100, small_radius, true, 3)
    for _,v in pairs(targets_small_radius) do
        if v ~= attacker and v ~= target then
        	v.damage_from_splash = medium_damage
            ApplyDamage({ victim = v, attacker = attacker, damage = small_damage, damage_type = DAMAGE_TYPE_PHYSICAL})
        end
    end
end