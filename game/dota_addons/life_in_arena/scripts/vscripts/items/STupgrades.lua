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
				newAbi = "hermit_frost_arrows_staff",
				tPassiveModifiers_by_oldAbi = {"modifier_frost_arrows_caster_datadriven"},
			}
			ReplaceAbi(par)
			--
			par = {
				unit = caster,
				oldAbi = "hermit_summon_water_elemental_new",
				newAbi = "hermit_summon_water_elemental_new_staff",
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
				newAbi = "paladin_blizzard_staff",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			par = {
				unit = caster,
				oldAbi = "paladin_grace",
				newAbi = "paladin_grace_staff",
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
				newAbi = "skeleton_mage_light_magic_staff",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			par = {
				unit = caster,
				oldAbi = "skeleton_mage_dark_magic",
				newAbi = "skeleton_mage_dark_magic_staff",
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
				newAbi = "earth_lord_earth_burn_staff",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			par = {
				unit = caster,
				oldAbi = "earth_lord_split_earth",
				newAbi = "earth_lord_split_earth_staff",
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
				newAbi = "frost_lord_frost_breath_staff",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			par = {
				unit = caster,
				oldAbi = "frost_lord_ice",
				newAbi = "frost_lord_ice_staff",
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
				newAbi = "time_lord_death_staff",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			par = {
				unit = caster,
				oldAbi = "time_lord_timelapse",
				newAbi = "time_lord_timelapse_staff",
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
				newAbi = "vowen_from_blood_steal_blood_staff",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			par = {
				unit = caster,
				oldAbi = "vowen_from_blood_spiritual_flame",
				newAbi = "vowen_from_blood_spiritual_flame_staff",
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
				newAbi = "warlock_storm_datadriven_staff",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			par = {
				unit = caster,
				oldAbi = "warlock_firestorm_datadriven",
				newAbi = "warlock_firestorm_datadriven_staff",
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
				newAbi = "witch_doctor_negative_energy_staff",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			par = {
				unit = caster,
				oldAbi = "witch_doctor_frost_armor",
				newAbi = "witch_doctor_frost_armor_staff",
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
				newAbi = "keeper_of_the_grove_guardian_spirit_staff",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			par = {
				unit = caster,
				oldAbi = "keeper_of_the_grove_natures_curse",
				newAbi = "keeper_of_the_grove_natures_curse_staff",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			caster.STupgrades = true
		end			
		if name == "npc_dota_hero_mirana" then
			par = {
				unit = caster,
				oldAbi = "ancient_priestess_mana_shield",
				newAbi = "ancient_priestess_mana_shield_staff",
				tPassiveModifiers_by_oldAbi = {"modifier_ancient_priestess_mana_shield"},
			}
			ReplaceAbi(par)
			--
			par = {
				unit = caster,
				oldAbi = "ancient_priestess_ritual_protection",
				newAbi = "ancient_priestess_ritual_protection_staff",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			caster.STupgrades = true
		end		
		if name == "npc_dota_hero_disruptor" then
			par = {
				unit = caster,
				oldAbi = "lord_of_lightning_lightning_shield",
				newAbi = "lord_of_lightning_lightning_shield_staff",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			par = {
				unit = caster,
				oldAbi = "lord_of_lightning_chain_lightning",
				newAbi = "lord_of_lightning_chain_lightning_staff",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			caster.STupgrades = true
		end			
		
		if name == "npc_dota_hero_silencer" then
			par = {
				unit = caster,
				oldAbi = "wanderer_the_flow_of_life",
				newAbi = "wanderer_the_flow_of_life_staff",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			par = {
				unit = caster,
				oldAbi = "wanderer_ghosts",
				newAbi = "wanderer_ghosts_staff",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			caster.STupgrades = true
		end		

		if name == "npc_dota_hero_invoker" then
			par = {
				unit = caster,
				oldAbi = "firelord_flame_strike",
				newAbi = "firelord_flame_strike_staff",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			par = {
				unit = caster,
				oldAbi = "firelord_fire_serpent",
				newAbi = "firelord_fire_serpent_staff",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			caster.STupgrades = true
		end		

		if name == "npc_dota_hero_abyssal_underlord" then
			par = {
				unit = caster,
				oldAbi = "necromancer_stabbing_death",
				newAbi = "necromancer_stabbing_death_staff",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			par = {
				unit = caster,
				oldAbi = "necromancer_deads",
				newAbi = "necromancer_deads_staff",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			caster.STupgrades = true
		end	

		if name == "npc_dota_hero_keeper_of_the_light" then
			par = {
				unit = caster,
				oldAbi = "archmage_shooting_star",
				newAbi = "archmage_shooting_star_staff",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			par = {
				unit = caster,
				oldAbi = "archmage_anomaly",
				newAbi = "archmage_anomaly_staff",
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
				oldAbi = "hermit_frost_arrows_staff",
				newAbi = "hermit_frost_arrows",
				tPassiveModifiers_by_oldAbi = {"modifier_frost_arrows_caster_datadriven"},
			}
			ReplaceAbi(par)
			--
			par = {
				unit = caster,
				oldAbi = "hermit_summon_water_elemental_new_staff",
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
				oldAbi = "paladin_blizzard_staff",
				newAbi = "paladin_blizzard",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			par = {
				unit = caster,
				oldAbi = "paladin_grace_staff",
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
				oldAbi = "skeleton_mage_light_magic_staff",
				newAbi = "skeleton_mage_light_magic",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			par = {
				unit = caster,
				oldAbi = "skeleton_mage_dark_magic_staff",
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
				oldAbi = "earth_lord_earth_burn_staff",
				newAbi = "earth_lord_earth_burn",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			par = {
				unit = caster,
				oldAbi = "earth_lord_split_earth_staff",
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
				oldAbi = "frost_lord_frost_breath_staff",
				newAbi = "frost_lord_frost_breath",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			par = {
				unit = caster,
				oldAbi = "frost_lord_ice_staff",
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
				oldAbi = "time_lord_death_staff",
				newAbi = "time_lord_death",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			par = {
				unit = caster,
				oldAbi = "time_lord_timelapse_staff",
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
				oldAbi = "vowen_from_blood_steal_blood_staff",
				newAbi = "vowen_from_blood_steal_blood",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			par = {
				unit = caster,
				oldAbi = "vowen_from_blood_spiritual_flame_staff",
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
				oldAbi = "warlock_storm_datadriven_staff",
				newAbi = "warlock_storm_datadriven",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			par = {
				unit = caster,
				oldAbi = "warlock_firestorm_datadriven_staff",
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
				oldAbi = "witch_doctor_negative_energy_staff",
				newAbi = "witch_doctor_negative_energy",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			par = {
				unit = caster,
				oldAbi = "witch_doctor_frost_armor_staff",
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
				oldAbi = "keeper_of_the_grove_guardian_spirit_staff",
				newAbi = "keeper_of_the_grove_guardian_spirit",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			par = {
				unit = caster,
				oldAbi = "keeper_of_the_grove_natures_curse_staff",
				newAbi = "keeper_of_the_grove_natures_curse",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			caster.STupgrades = false
		end
		
		if name == "npc_dota_hero_mirana" then
			par = {
				unit = caster,
				oldAbi = "ancient_priestess_mana_shield_staff",
				newAbi = "ancient_priestess_mana_shield",
				tPassiveModifiers_by_oldAbi = {"modifier_ancient_priestess_mana_shield"},
			}
			ReplaceAbi(par)
			--
			par = {
				unit = caster,
				oldAbi = "ancient_priestess_ritual_protection_staff",
				newAbi = "ancient_priestess_ritual_protection",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			caster.STupgrades = false
		end
		--
		if name == "npc_dota_hero_disruptor" then
			par = {
				unit = caster,
				oldAbi = "lord_of_lightning_lightning_shield_staff",
				newAbi = "lord_of_lightning_lightning_shield",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			par = {
				unit = caster,
				oldAbi = "lord_of_lightning_chain_lightning_staff",
				newAbi = "lord_of_lightning_chain_lightning",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			caster.STupgrades = false
		end
		
		if name == "npc_dota_hero_silencer" then
			par = {
				unit = caster,
				oldAbi = "wanderer_the_flow_of_life_staff",
				newAbi = "wanderer_the_flow_of_life",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			par = {
				unit = caster,
				oldAbi = "wanderer_ghosts_staff",
				newAbi = "wanderer_ghosts",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			caster.STupgrades = false
		end		

		if name == "npc_dota_hero_invoker" then
			par = {
				unit = caster,
				oldAbi = "firelord_flame_strike_staff",
				newAbi = "firelord_flame_strike",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			par = {
				unit = caster,
				oldAbi = "firelord_fire_serpent_staff",
				newAbi = "firelord_fire_serpent",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			caster.STupgrades = false
		end			
		
		if name == "npc_dota_hero_abyssal_underlord" then
			par = {
				unit = caster,
				oldAbi = "necromancer_stabbing_death_staff",
				newAbi = "necromancer_stabbing_death",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			par = {
				unit = caster,
				oldAbi = "necromancer_deads_staff",
				newAbi = "necromancer_deads",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			caster.STupgrades = false
		end	

		if name == "npc_dota_hero_keeper_of_the_light" then
			par = {
				unit = caster,
				oldAbi = "archmage_shooting_star_staff",
				newAbi = "archmage_shooting_star",
				tPassiveModifiers_by_oldAbi = {},
			}
			ReplaceAbi(par)
			--
			par = {
				unit = caster,
				oldAbi = "archmage_anomaly_staff",
				newAbi = "archmage_anomaly",
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

	autocast = ability:GetAutoCastState()

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

