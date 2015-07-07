modifier_hermit_summon_water_elemental = class ({})


--function modifier_hermit_summon_water_elemental:IsPurgable()
--	return true
--end 

--function modifier_hermit_summon_water_elemental:IsBuff()
--	return true
--end 

--function modifier_hermit_summon_water_elemental:GetEffectName()
--	return "particles/units/heroes/hero_night_stalker/nightstalker_void.vpcf"
--end

--function modifier_hermit_summon_water_elemental:GetEffectAttachType()
--	return PATTACH_ABSORIGIN_FOLLOW
--end

----------------------------------------------

--function modifier_hermit_summon_water_elemental:DeclareFunctions()
--	local funcs = {
--		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
--		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
--		MODIFIER_EVENT_ON_ATTACK_LANDED,
--	}
-- 
--	return funcs
--end

--function modifier_hermit_summon_water_elemental:GetModifierAttackSpeedBonus_Constant(params)
--	return self.bonus_attack_speed
--end

--function modifier_hermit_summon_water_elemental:GetModifierPreAttack_BonusDamage(params)
--	return self.bonus_damage
--end

function modifier_hermit_summon_water_elemental:OnCreated(params)
		local hCaster = self:GetCaster()
		local ability = self:GetAbility()
		local lvl = ability:GetLevel()-1
		local unitname
		local PID = hCaster:GetPlayerOwnerID()
		local cre
		--
		local num = ability:GetSpecialValueFor( "unit_count" )
		local durat = ability:GetSpecialValueFor( "duration" )
		local obl = ability:GetSpecialValueFor( "spawn_radius" )
		--
		if not ability.tUnits then
			ability.tUnits = {}
		else
			for i=1, #ability.tUnits do
				if not ability.tUnits[i]:IsNull() then
					ability.tUnits[i]:ForceKill(false)
				end
				--ability.tUnits[i]:AddNewModifier(hCaster, nil, "modifier_kill", { duration = 0.00 })
			end
			ability.tUnits = {}
		end
		--
		local flag = false
		if hCaster:HasItemInInventory("item_lia_spherical_staff") then
			--unitname = "npc_water_elemental_4"
			if lvl == 0 then
				unitname = "npc_water_elemental_2"
			end
			if lvl == 1 then
				unitname = "npc_water_elemental_3"
			end
			if lvl == 2 then
				flag = true
				unitname = "npc_water_elemental_4"
			end
		else
			if lvl == 0 then
				unitname = "npc_water_elemental_1"
			end
			if lvl == 1 then
				unitname = "npc_water_elemental_2"
			end
			if lvl == 2 then
				unitname = "npc_water_elemental_3"
			end
		end

		--
		--PrecacheUnitByNameAsync(unitname, function(...) end)
		for i=1, num do
			cre = CreateUnitByName(unitname, hCaster:GetAbsOrigin() + RandomVector(RandomInt(-obl,obl )), false, hCaster, hCaster, hCaster:GetTeam())
			cre:SetControllableByPlayer(PID, false)
			--
			cre:AddNewModifier(hCaster, nil, "modifier_kill", { duration = durat })
			cre:AddNewModifier(hCaster, nil, "modifier_phased", { duration = 0.03 })
			--
			if hCaster:HasModifier("modifier_decrepify_units_by_hero") then
				hCaster:FindAbilityByName("hermit_astral"):ApplyDataDrivenModifier( hCaster, cre, 'modifier_decrepify_units_by_hero', {} )
			end
			--
			if flag then
				cre:SetRenderColor(255,0,0)
			end
			--
			table.insert(ability.tUnits,cre)
		end
		--ability:ApplyDataDrivenModifier( hCaster, hCaster, modname, {duration = 0.03} )

end

--function modifier_hermit_summon_water_elemental:OnAttackLanded(params)
--	if IsServer() then
--
--	end
--end

