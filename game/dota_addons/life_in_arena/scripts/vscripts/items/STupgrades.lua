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
		
	end
	--end
	--if caster:HasItemInInventory("item_lia_spherical_staff") then
	--
	--end
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
	for i=1, #tPassiveModifiers_by_oldAbi do
		--if not unit:FindModifierByName(tPassiveModifiers_by_oldAbi[i]):IsNull() then
		if unit:FindModifierByName(tPassiveModifiers_by_oldAbi[i]) ~= nil then
			unit:RemoveModifierByName(tPassiveModifiers_by_oldAbi[i])
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

