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
			}
			ReplaceAbi(par)
			--
			par = {
				unit = caster,
				oldAbi = "hermit_summon_water_elemental_new",
				newAbi = "hermit_summon_water_elemental_new_scepter",
			}
			ReplaceAbi(par)
			--
			caster.STupgrades = true
		end
		--
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
			}
			ReplaceAbi(par)
			--
			par = {
				unit = caster,
				oldAbi = "hermit_summon_water_elemental_new_scepter",
				newAbi = "hermit_summon_water_elemental_new",
			}
			ReplaceAbi(par)
			--
			caster.STupgrades = false
		end
		-- next heroes
		
	end
	--end
	--if caster:HasItemInInventory("item_lia_spherical_staff") then
	--
	--end
end

function ReplaceAbi(params)
	local ability
	local abilityNew
	local cooldownRe
	local lvlRe
	local unit = params.unit
	local oldAbi = params.oldAbi
	local newAbi = params.newAbi
	--
	ability = unit:FindAbilityByName(oldAbi)
	cooldownRe = ability:GetCooldownTimeRemaining()
	lvlRe = ability:GetLevel()
	print(cooldownRe)
	unit:RemoveAbility(oldAbi)
	unit:AddAbility(newAbi)
	abilityNew = unit:FindAbilityByName(newAbi)
	abilityNew:SetLevel(lvlRe)
	abilityNew:StartCooldown(cooldownRe)
end

