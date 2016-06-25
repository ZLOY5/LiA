function modifier_item_blood_blade_datadriven_on_orb_impact(keys)
	if --[[keys.target:GetInvulnCount() == nil and]] keys.target:GetTeamNumber() ~= keys.caster:GetTeamNumber() and not keys.caster:HasAbility("vampire_lifesteal")  then
		keys.ability:ApplyDataDrivenModifier(keys.attacker, keys.attacker, "modifier_item_blood_blade_datadriven_lifesteal", {duration = 0.03})
	end
end

function OnSpellStart(event)
	local damageTable = {
		victim = nil,
		attacker = event.caster,
		damage = 0,
		damage_type = DAMAGE_TYPE_PURE,
		ability = event.ability
	}
	local heal_amount = 0
    local units = FindUnitsInRadius(event.caster:GetTeam(),
									event.caster:GetAbsOrigin(),
									nil,
									event.radius,
									DOTA_UNIT_TARGET_TEAM_ENEMY,
									DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
									DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
									FIND_ANY_ORDER,
									false)
    for _, unit in pairs(units) do 
    	if unit:IsAlive() and unit:GetHealthPercent() >= 50 then
    		damageTable.damage = unit:GetMaxHealth() * event.stealperc * 0.01
    		damageTable.victim = unit
    		heal_amount = heal_amount + ApplyDamage(damageTable)
    	end
    end
    if heal_amount > event.maxheal then
    	heal_amount = event.maxheal
    end
    event.caster:Heal(heal_amount,event.caster)
end