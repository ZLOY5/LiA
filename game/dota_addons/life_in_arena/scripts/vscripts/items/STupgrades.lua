function OnEquip(event)
	local caster = event.caster
	local name = caster:GetUnitName()
	local par
	--
	-- names of heroes-mages
	--if name == "npc_dota_hero_bane" then --or "" then
	--
	if not caster.STupgrades then
		caster.STupgrades = false
	end
	--
	if caster.STupgrades == false then
		-- replace abilityes
		-- bane
		-- 3 frost arrows
		-- remember cooldown
		if name == "npc_dota_hero_bane" then
			par = {
				unit = caster,
				oldAbi = "hermit_frost_arrows",
				newAbi = "hermit_frost_arrows_scepter",
				tPassiveModifiers_by_oldAbi = {"modifier_frost_arrows_caster_datadriven"},
			}
			ReplaceAbi(par)
			--
			par = {
				unit = caster,
				oldAbi = "hermit_summon_water_elemental_new",
				newAbi = "hermit_summon_water_elemental_new_scepter",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			caster.STupgrades = true
		end
		--
		if name == "npc_dota_hero_chen" then
			par = {
				unit = caster,
				oldAbi = "paladin_blizzard",
				newAbi = "paladin_blizzard_scepter",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			par = {
				unit = caster,
				oldAbi = "paladin_grace",
				newAbi = "paladin_grace_scepter",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			caster.STupgrades = true
		end
		--
		--
		if name == "npc_dota_hero_pugna" then
			par = {
				unit = caster,
				oldAbi = "skeleton_mage_light_magic",
				newAbi = "skeleton_mage_light_magic_scepter",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			par = {
				unit = caster,
				oldAbi = "skeleton_mage_dark_magic",
				newAbi = "skeleton_mage_dark_magic_scepter",
				tPassiveModifiers_by_oldAbi = {},--{"modifier_skeleton_mage_dark_magic"},
			}
			ReplaceAbi(par)
			--
			caster.STupgrades = true
		end
		--
		if name == "npc_dota_hero_warlock" then
			par = {
				unit = caster,
				oldAbi = "earth_lord_earth_burn",
				newAbi = "earth_lord_earth_burn_scepter",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			par = {
				unit = caster,
				oldAbi = "earth_lord_split_earth",
				newAbi = "earth_lord_split_earth_scepter",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			caster.STupgrades = true
		end
		--
		if name == "npc_dota_hero_lich" then
			par = {
				unit = caster,
				oldAbi = "frost_lord_frost_breath",
				newAbi = "frost_lord_frost_breath_scepter",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			par = {
				unit = caster,
				oldAbi = "frost_lord_ice",
				newAbi = "frost_lord_ice_scepter",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			caster.STupgrades = true
		end
		--
		if name == "npc_dota_hero_spirit_breaker" then
			par = {
				unit = caster,
				oldAbi = "time_lord_death",
				newAbi = "time_lord_death_scepter",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			par = {
				unit = caster,
				oldAbi = "time_lord_timelapse",
				newAbi = "time_lord_timelapse_scepter",
				tPassiveModifiers_by_oldAbi = {"modifier_time_lord_timelapse"},
			}
			ReplaceAbi(par)
			--
			caster.STupgrades = true
		end
		--
		if name == "npc_dota_hero_nevermore" then
			par = {
				unit = caster,
				oldAbi = "vowen_from_blood_steal_blood",
				newAbi = "vowen_from_blood_steal_blood_scepter",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			par = {
				unit = caster,
				oldAbi = "vowen_from_blood_spiritual_flame",
				newAbi = "vowen_from_blood_spiritual_flame_scepter",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			caster.STupgrades = true
		end
		--
		if name == "npc_dota_hero_lion" then
			par = {
				unit = caster,
				oldAbi = "warlock_storm_datadriven",
				newAbi = "warlock_storm_datadriven_scepter",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			par = {
				unit = caster,
				oldAbi = "warlock_firestorm_datadriven",
				newAbi = "warlock_firestorm_datadriven_scepter",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			caster.STupgrades = true
		end
		--
		if name == "npc_dota_hero_shadow_shaman" then
			par = {
				group = caster.groupArmor,
				nameModifier = "modifier_frost_armor",
			}
			deleteModifierFromAllGlobalUnits(par)
			caster.groupArmor = {}
			--
			par = {
				unit = caster,
				oldAbi = "witch_doctor_negative_energy",
				newAbi = "witch_doctor_negative_energy_scepter",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			par = {
				unit = caster,
				oldAbi = "witch_doctor_frost_armor",
				newAbi = "witch_doctor_frost_armor_scepter",
				tPassiveModifiers_by_oldAbi = {"modifier_frost_armor_autocast_aura"},
			}
			ReplaceAbi(par)
			--
			caster.STupgrades = true
		end
		
		if name == "npc_dota_hero_leshrac" then
			par = {
				unit = caster,
				oldAbi = "keeper_of_the_grove_guardian_spirit",
				newAbi = "keeper_of_the_grove_guardian_spirit_scepter",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			par = {
				unit = caster,
				oldAbi = "keeper_of_the_grove_natures_curse",
				newAbi = "keeper_of_the_grove_natures_curse_scepter",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			caster.STupgrades = true
		end			
		-- next heroes
	end
	--end
	--if caster:HasItemInInventory("item_lia_spherical_staff") then
	--
	--end
	
end

function OnUnequip(event)
	local caster = event.caster
	local name = caster:GetUnitName()
	local par
	--
	-- names of heroes-mages
	--if name == "npc_dota_hero_bane" then --or "" then
	--
	if not caster.STupgrades then
		caster.STupgrades = false
	end
	--
	if not caster:HasItemInInventory("item_lia_spherical_staff") then
	--if caster.STupgrades == false then
		-- replace abilityes
		-- bane
		-- 3 frost arrows
		-- remember cooldown
		
		if name == "npc_dota_hero_bane" then
			par = {
				unit = caster,
				oldAbi = "hermit_frost_arrows_scepter",
				newAbi = "hermit_frost_arrows",
				tPassiveModifiers_by_oldAbi = {"modifier_frost_arrows_caster_datadriven"},
			}
			ReplaceAbi(par)
			--
			par = {
				unit = caster,
				oldAbi = "hermit_summon_water_elemental_new_scepter",
				newAbi = "hermit_summon_water_elemental_new",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			caster.STupgrades = false
		end
		-- next heroes
		--
		if name == "npc_dota_hero_chen" then
			par = {
				unit = caster,
				oldAbi = "paladin_blizzard_scepter",
				newAbi = "paladin_blizzard",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			par = {
				unit = caster,
				oldAbi = "paladin_grace_scepter",
				newAbi = "paladin_grace",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			caster.STupgrades = false
		end
		--
		--
		if name == "npc_dota_hero_pugna" then
			par = {
				unit = caster,
				oldAbi = "skeleton_mage_light_magic_scepter",
				newAbi = "skeleton_mage_light_magic",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			par = {
				unit = caster,
				oldAbi = "skeleton_mage_dark_magic_scepter",
				newAbi = "skeleton_mage_dark_magic",
				tPassiveModifiers_by_oldAbi = {},--{"modifier_skeleton_mage_dark_magic"},
			}
			ReplaceAbi(par)
			--
			caster.STupgrades = false
		end
		--
		if name == "npc_dota_hero_warlock" then
			par = {
				unit = caster,
				oldAbi = "earth_lord_earth_burn_scepter",
				newAbi = "earth_lord_earth_burn",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			par = {
				unit = caster,
				oldAbi = "earth_lord_split_earth_scepter",
				newAbi = "earth_lord_split_earth",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			caster.STupgrades = false
		end
		--
		if name == "npc_dota_hero_lich" then
			par = {
				unit = caster,
				oldAbi = "frost_lord_frost_breath_scepter",
				newAbi = "frost_lord_frost_breath",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			par = {
				unit = caster,
				oldAbi = "frost_lord_ice_scepter",
				newAbi = "frost_lord_ice",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			caster.STupgrades = false
		end
		--
		if name == "npc_dota_hero_spirit_breaker" then
			par = {
				unit = caster,
				oldAbi = "time_lord_death_scepter",
				newAbi = "time_lord_death",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			par = {
				unit = caster,
				oldAbi = "time_lord_timelapse_scepter",
				newAbi = "time_lord_timelapse",
				tPassiveModifiers_by_oldAbi = {"modifier_time_lord_timelapse"},
			}
			ReplaceAbi(par)
			--
			caster.STupgrades = false
		end
		--
		if name == "npc_dota_hero_nevermore" then
			par = {
				unit = caster,
				oldAbi = "vowen_from_blood_steal_blood_scepter",
				newAbi = "vowen_from_blood_steal_blood",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			par = {
				unit = caster,
				oldAbi = "vowen_from_blood_spiritual_flame_scepter",
				newAbi = "vowen_from_blood_spiritual_flame",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			caster.STupgrades = false
		end
		--
		if name == "npc_dota_hero_lion" then
			par = {
				unit = caster,
				oldAbi = "warlock_storm_datadriven_scepter",
				newAbi = "warlock_storm_datadriven",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			par = {
				unit = caster,
				oldAbi = "warlock_firestorm_datadriven_scepter",
				newAbi = "warlock_firestorm_datadriven",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			caster.STupgrades = false
		end
		--
		if name == "npc_dota_hero_shadow_shaman" then
			par = {
				group = caster.groupArmor,
				nameModifier = "modifier_frost_armor",
			}
			deleteModifierFromAllGlobalUnits(par)
			caster.groupArmor = {}
			--
			par = {
				unit = caster,
				oldAbi = "witch_doctor_negative_energy_scepter",
				newAbi = "witch_doctor_negative_energy",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			par = {
				unit = caster,
				oldAbi = "witch_doctor_frost_armor_scepter",
				newAbi = "witch_doctor_frost_armor",
				tPassiveModifiers_by_oldAbi = {"modifier_frost_armor_autocast_aura"},
			}
			ReplaceAbi(par)
			--
			caster.STupgrades = false
		end

		if name == "npc_dota_hero_leshrac" then
			par = {
				unit = caster,
				oldAbi = "keeper_of_the_grove_guardian_spirit_scepter",
				newAbi = "keeper_of_the_grove_guardian_spirit",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			par = {
				unit = caster,
				oldAbi = "keeper_of_the_grove_natures_curse_scepter",
				newAbi = "keeper_of_the_grove_natures_curse",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			caster.STupgrades = false
		end	
	end
	--end
	--if caster:HasItemInInventory("item_lia_spherical_staff") then
	--
	--end
end

function deleteModifierFromAllGlobalUnits(params)
	local group = params.group
	local nameModifier = params.nameModifier
	--for k,unit in pairs(ability.tAlliesPal) do
	if group~= nil then
		for i = 1, #group do
			if not group[i]:IsNull() then
				group[i]:RemoveModifierByName(nameModifier)
				--print("RemoveModifierByName ",group[i]:GetUnitName())
			end
			--table.remove(ability.tAlliesPal,i)
		end
	end
	--ability.tAlliesPal = {}
end

function ReplaceAbi(params)
	--local maxPassiveModifiers = 6
	--local modifier
	local autocast
	local buf
	local ability
	local abilityNew
	local cooldownRe
	local lvlRe
	local unit = params.unit
	local oldAbi = params.oldAbi
	local newAbi = params.newAbi
	local tPassiveModifiers_by_oldAbi = params.tPassiveModifiers_by_oldAbi
	--
	ability = unit:FindAbilityByName(oldAbi)
	cooldownRe = ability:GetCooldownTimeRemaining()
	lvlRe = ability:GetLevel()
	--print(cooldownRe)
	
	-- also remove all passive modifiers
	-- if this need
	if tPassiveModifiers_by_oldAbi ~= nil then
		for i=1, #tPassiveModifiers_by_oldAbi do
			--if not unit:FindModifierByName(tPassiveModifiers_by_oldAbi[i]):IsNull() then
			if unit:FindModifierByName(tPassiveModifiers_by_oldAbi[i]) ~= nil then
				unit:RemoveModifierByName(tPassiveModifiers_by_oldAbi[i])
			end
		end
	end
	-- autocast state
	if ability:GetAutoCastState() ~= nil then
		autocast = ability:GetAutoCastState()
	else
		autocast = false
	end
	--
	unit:RemoveAbility(oldAbi)
	--
	unit:AddAbility(newAbi)
	abilityNew = unit:FindAbilityByName(newAbi)
	abilityNew:SetLevel(lvlRe)
	abilityNew:StartCooldown(cooldownRe)
	--
	if autocast then
		abilityNew:ToggleAutoCast()
	end
	--
end

